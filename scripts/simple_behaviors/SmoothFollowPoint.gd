extends Node2D


@export var to_follow: Node2D;
@export var speed : float = 1;
@export var speed_dim := Vector2(1, 5)

@export var distance_reference :float= 600;
@export var distance_scaling :float= 1;

var velocity : Vector2 = Vector2.ZERO

func _process(delta):
	if !to_follow: return;
	
	var direction := to_follow.global_position - global_position;
	var distance := direction.length()
	var velocity_direction := direction - velocity;
	
	var distance_factor := 1#clamp(pow(distance/distance_reference, distance_scaling), 1, 5) as float;
	#print("({2}) distance: {0} -> {1}, velocity: {3} ({4} -> {5})".format([distance, distance_factor, delta, velocity, global_position, to_follow.global_position]))
	velocity += GeometryUtils.multiply_memberwise2(velocity_direction *speed * delta * distance_factor, speed_dim)
	
	global_position.x += velocity.x * delta
	global_position.y = lerpf(global_position.y, to_follow.global_position.y, speed_dim.y *delta)
