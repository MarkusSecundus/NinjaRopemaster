extends Node2D
class_name ShootableRopeController

var rope_segment : PackedScene = preload("res://prefabs/rope/RopePiece.tscn");
var rope_hook : PackedScene = preload("res://prefabs/rope/RopeHookPiece.tscn");
var max_segments :int= 30
@export var shoot_force : float;


signal on_hook_hit(last_segment: RigidBody2D);


var _already_created := false
func create_the_rope(where_to_place:Node2D, target_position:Vector2)->void:
	if _already_created: return
	_already_created = true
	var direction := (target_position - where_to_place.global_position).limit_length(1.0)
	
	self.where_to_place = where_to_place;
	var look_direction := where_to_place.global_position - target_position;
	var hook = _spawn_segment(rope_hook, where_to_place.global_position, look_direction, null);
	hook_segment = hook
	hook.on_hit.connect(_on_shot_finished_callback)
	last_body = hook;
	hook.apply_impulse(direction * shoot_force);
	
	var temp := rope_segment.instantiate() as RigidBody2D;
	self.segment_length = _get_anchor_of_segment(temp).position.length()
	temp.queue_free()


func _on_shot_finished_callback():
	if is_finished: return
	is_finished = true;
	on_hook_hit.emit(last_body)


var is_frozen: bool:
	get: return hook_segment && hook_segment.is_frozen
var is_finished : bool = false;
var where_to_place : Node2D;
var last_body : RigidBody2D
var last_anchor_point : Node2D;
var segment_length : float = 0;
var hook_segment: RopeHookController;

var _segments_count = 0;
#func _integrate_forces(state: PhysicsDirectBodyState2D)->void:
func _physics_process(_delta):
	if is_finished: return
	
	#print("dst: {0} X {1}".format([where_to_place.global_position.distance_to(last_anchor_point.global_position), segment_length]))
	while !is_finished && (where_to_place.global_position.distance_to(last_anchor_point.global_position) >= segment_length*0.5):
		var look_direction := last_anchor_point.global_position - where_to_place.global_position
		last_body = _spawn_segment(rope_segment, last_anchor_point.global_position, -look_direction, last_body)
		_segments_count += 1
		if _segments_count >= max_segments:
			hook_segment.is_finished = true
			_on_shot_finished_callback()




func _spawn_segment(segment_prefab:PackedScene, parent_anchor_point : Vector2, look_direction: Vector2, body_to_connect: RigidBody2D)->RigidBody2D:
	
	var new_segment := segment_prefab.instantiate() as RigidBody2D
	get_tree().root.add_child(new_segment)
	var anchor_point_marker := _get_anchor_of_segment(new_segment)
	last_anchor_point = anchor_point_marker;
	
	new_segment.global_position = parent_anchor_point
	var joint := _get_joint_of_segment(new_segment);
	

	var to_rotate := -GeometryUtils.look_at_rotation_rad(look_direction);
	new_segment.rotation += to_rotate;
	
	if body_to_connect: 
		#var segment_dimensions := Vector2.ZERO - anchor_point_marker.position
		#self.segment_length = segment_dimensions.length()
		joint.node_b = body_to_connect.get_path()
	
	return new_segment;


var climb_progress :float= 0.0

func get_climb_point()->Vector2:
	return lerp(_get_anchor_of_segment(last_body).global_position, last_body.global_position, climb_progress) as Vector2

func progress_the_climb(distance_traveled: float, min_segments_remaining: int=0)->bool:
	climb_progress += distance_traveled / segment_length
	while(climb_progress >= 1):
		if _segments_count <= min_segments_remaining || !destroy_last_segment():
			climb_progress = clampf(climb_progress, 0, 1)
			return false
		climb_progress -= 1
	return true

func destroy_last_segment()->RigidBody2D:
	if !is_finished:
		ErrorUtils.report_warning("Destroying rope segments but rope generation hadn't yet finished!")
		_on_shot_finished_callback()
	if !last_body: return null
	var to_destroy := last_body
	last_body = _get_predecessor_of_segment(last_body)
	to_destroy.queue_free()
	if last_body is RopeHookController:
		last_body.queue_free()
		return null
	_segments_count -= 1
	return last_body


func _get_joint_of_segment(segment: RigidBody2D)->PinJoint2D: 
	if !segment: return null
	return segment.get_node("Joint") as PinJoint2D;
func _get_anchor_of_segment(segment: RigidBody2D)->Node2D:
	if !segment: return null
	return segment.get_node("AnchorPointMarker") as Node2D;
func _get_predecessor_of_segment(segment: RigidBody2D)->RigidBody2D:
	var joint :=_get_joint_of_segment(segment)
	if !joint: return null
	var path := joint.node_b
	if path: return get_node(path) as RigidBody2D;
	else: return null;
