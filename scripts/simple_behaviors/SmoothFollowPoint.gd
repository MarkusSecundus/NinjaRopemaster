extends Node2D


@export var to_follow: Node2D;
@export var max_speed : float = INF;
@export var speed : float = 1;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !to_follow: return;
	
	var direction := to_follow.global_position - global_position;
	var distance := direction.length();
	direction = direction.normalized();
	var max_distance := max_speed /speed;
	distance = min(distance, max_distance)
	global_position += direction* distance *speed * delta;
