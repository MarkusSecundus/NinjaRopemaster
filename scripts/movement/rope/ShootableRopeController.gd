extends Node2D
class_name ShootableRopeController

var rope_segment : PackedScene = preload("res://prefabs/rope/RopePiece.tscn");
var rope_hook : PackedScene = preload("res://prefabs/rope/RopeHookPiece.tscn")
@export var shoot_force : float;



var _already_created := false
func create_the_rope(where_to_place:Node2D, target_position:Vector2)->void:
	if _already_created: return
	_already_created = true
	var direction := (target_position - where_to_place.global_position).limit_length(1.0)
	var length_remaining := direction.length()
	
	self.where_to_place = where_to_place;
	var look_direction := where_to_place.global_position - target_position;
	var hook = _spawn_segment(rope_hook, where_to_place.global_position, look_direction, null);
	hook.on_hit.connect(_on_hit_callback)
	last_body = _spawn_segment(rope_segment, _get_anchor_of_segment(hook).global_position, look_direction, hook);
	hook.apply_impulse(direction * shoot_force);


func _on_hit_callback():
	print("hit the ground")
	is_finished = true;


var is_finished : bool = false;
var where_to_place : Node2D;
var last_body : PhysicsBody2D
var last_anchor_point : Node2D;
var segment_length : float = 0;
func _process(delta):
	if is_finished: return
	
	var anchor_point := last_anchor_point.global_position;
	print("dst: {0} X {1}".format([where_to_place.global_position.distance_to(anchor_point), segment_length]))
	if(where_to_place.global_position.distance_to(anchor_point) >= segment_length):
		last_body = _spawn_segment(rope_segment, anchor_point, last_body.global_position, last_body)


func _spawn_segment(segment_prefab:PackedScene, parent_anchor_point : Vector2, look_direction: Vector2, body_to_connect: RigidBody2D)->RigidBody2D:
	
	var new_segment := segment_prefab.instantiate() as RigidBody2D
	self.add_child(new_segment)
	var anchor_point_marker := _get_anchor_of_segment(new_segment)
	last_anchor_point = anchor_point_marker;
	
	new_segment.global_position = parent_anchor_point
	var joint := _get_joint_of_segment(new_segment);
	

	var to_rotate := -GeometryUtils.look_at_rotation_rad(look_direction);
	new_segment.rotation += to_rotate;
	
	if body_to_connect: 
		var segment_dimensions := Vector2.ZERO - anchor_point_marker.position
		self.segment_length = segment_dimensions.length()
		joint.node_b = body_to_connect.get_path()
	
	return new_segment;


func _get_joint_of_segment(segment: RigidBody2D)->PinJoint2D: return segment.get_node("Joint") as PinJoint2D;
func _get_anchor_of_segment(segment: RigidBody2D)->Node2D: return segment.get_node("AnchorPointMarker") as Node2D;
