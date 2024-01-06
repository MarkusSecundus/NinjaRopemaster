extends Node
class_name RopeController

@export var rope_segment : PackedScene

@onready var anchor_point : StaticBody2D = $AnchorBody;
@export var end_point : Node2D;

func _unhandled_key_input(event):
	return
	if event.is_action_pressed("Jump"):
		create_the_rope();

var _already_created := false
func create_the_rope()->void:
	if _already_created: return
	_already_created = true
	print("starting rope creation!")
	var direction = end_point.global_position - anchor_point.global_position
	var length_remaining = direction.length()
	
	var last_body : PhysicsBody2D = anchor_point
	var last_point : Node2D = anchor_point
	while(length_remaining > 0):
		var new_segment = rope_segment.instantiate() as RigidBody2D
		self.add_child(new_segment)
		var joint = new_segment.get_node("Joint") as PinJoint2D
		var anchor_point_marker = new_segment.get_node("AnchorPointMarker") as Node2D
		var segment_size = joint.global_position - anchor_point_marker.global_position
		
		new_segment.global_position =  last_point.global_position - joint.position
		print("adding a segment at {0} ({1}) - segment size is {2}".format([new_segment.global_position, new_segment.position, segment_size]))
		var to_rotate = -GeometryUtils.look_at_rotation_rad(direction) 
		new_segment.rotation += to_rotate
		
		joint.node_b = last_body.get_path()
		
		length_remaining -= segment_size.length()
		last_body = new_segment
		last_point = anchor_point_marker
		
		
	print("rope created")
