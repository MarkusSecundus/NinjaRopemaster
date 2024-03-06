extends Node


var deaths_count : int = 0;
var ropes_shot_total: int=0;
var ropes_shot_successful: int=0;
var ropes_shot_unsuccessful: int:
	get: return ropes_shot_total - ropes_shot_successful;
var jump_count : int = 0;
var rope_jump_count : int = 0;

var max_achieved_velocity : float = 0.0;

func _update_player_record_stats(player_body: RigidBody2D)->void:
	max_achieved_velocity = max(max_achieved_velocity, player_body.linear_velocity.length())
