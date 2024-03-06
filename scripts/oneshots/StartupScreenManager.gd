extends Node

@export var transition_fade: FancyFade
@export var next_scene : PackedScene

@export var rope : RopeController;
@export var ninja: PlayerController;

@export var impulse : Vector2

func _ready()->void:
	if false:
		rope.end_point.global_position = ninja.global_position
		rope.create_the_rope()
		ninja._hand_joint.node_b = rope.last_segment.get_path()
		ninja._animator.play("IdleWithRope")
		ninja.apply_impulse(impulse)


func _input(event)->void:
	if Input.is_key_pressed(KEY_SPACE):
		_do_tranisition_scene()

func _do_tranisition_scene()->void:
	transition_fade.fade_in(func():
		get_tree().change_scene_to_packed(next_scene)
	);
