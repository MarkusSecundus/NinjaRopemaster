extends Node
class_name RopeController

@export var rope_segment : PackedScene


@onready var anchor_point : StaticBody2D = $AnchorBody;
@onready var end_point : Node2D = $EndPointMarker;


func _create_the_rope()->void:
	var direction = end_point.position - anchor_point.position
	var length_remaining = direction.length()
	
	var last_body : PhysicsBody2D = anchor_point
	var last_point : Node2D = anchor_point
	while(length_remaining > 0):
		var new_segment = rope_segment.instantiate() as RigidBody2D
		self.add_child(new_segment)
		var joint = new_segment.get_node("Joint") as PinJoint2D
		var anchor_point_marker = new_segment.get_node("AnchorPointMarker") as Node2D
		
		
		pass
	
	pass
