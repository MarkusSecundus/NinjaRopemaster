extends Node2D

@export var rope_segment : PackedScene
@export var rope_hook : PackedScene
@export var shoot_force : float;

@onready var anchor_point : StaticBody2D = $AnchorBody;



var _already_created := false
func create_the_rope(where:Vector2)->void:
	if _already_created: return
	_already_created = true
	var direction = (where - anchor_point.global_position).limit_length(1.0)
	var length_remaining = direction.length()
	
	last_body  = anchor_point
	last_point = anchor_point


var last_body : PhysicsBody2D
var last_point : Node2D
func _spawn_next_segment(rope_segment: PackedScene)->RigidBody2D:
	
		var new_segment = rope_segment.instantiate() as RigidBody2D
		self.add_child(new_segment)
		var joint = new_segment.get_node("Joint") as PinJoint2D
		var anchor_point_marker = new_segment.get_node("AnchorPointMarker") as Node2D
		var segment_size = joint.global_position - anchor_point_marker.global_position
		
		new_segment.global_position =  last_point.global_position - joint.position
		#print("adding a segment at {0} ({1}) - segment size is {2}".format([new_segment.global_position, new_segment.position, segment_size]))
		var direction = last_point.global_position - anchor_point.global_position
		var to_rotate = -GeometryUtils.look_at_rotation_rad(direction) 
		new_segment.rotation += to_rotate
		
		joint.node_b = last_body.get_path()
		
		last_body = new_segment
		last_point = anchor_point_marker
		return new_segment
