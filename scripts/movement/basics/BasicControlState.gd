class_name BasicControlState
extends PlayerController.IControlState


@export var max_speed: int = 450
@export var acceleration : float = 3
@export var jump_force: Vector2 = Vector2(0,-600)
@export var air_control_factor : float = 0.3

@export var jump_press_tolerance_seconds : float = 0.3

var base : RigidBody2D:
	get: return base_controller as RigidBody2D

func activate():
	pass

func physics_process(delta):
	#if not base.is_on_floor(): base.velocity.y += base.gravity * delta
	if Input.is_action_pressed("Left"):
		move_direction(-max_speed)
	elif Input.is_action_pressed("Right"):
		move_direction(max_speed)
	else:
		move_direction(0)
		
	handle_jumping(Input.is_action_just_pressed("Jump"))
	
	#base.move_and_slide()
	#ScreenWrap.wrap_x_cbody(base)
		

func move_direction(direction: float)->void:
	if direction != 0: base._sprite.flip_h = (direction < 0)
	
	if !is_grounded(): 
		if direction == 0: return
		direction *= air_control_factor
	var velocity_direction = direction - base.linear_velocity.x
	var to_apply = Vector2(velocity_direction * acceleration, 0)
	#print("applying force {0} - velocity is {1}".format([to_apply, base.linear_velocity]))
	base.apply_force(to_apply)
	#base.gravity_scale = 1
	
	
var _last_jump_request_end : float = -INF
func handle_jumping(jump_was_requested : bool)->void:
	if is_grounded():
		if jump_was_requested || (_last_jump_request_end > TimeUtils.seconds_elapsed):
			_last_jump_request_end = -INF
			base.apply_impulse(jump_force)
			print("applying jump {0} - velocity is {1}".format([jump_force, base.linear_velocity]))
	elif jump_was_requested:
		_last_jump_request_end = TimeUtils.seconds_elapsed + jump_press_tolerance_seconds
	


func is_grounded()->bool:
	return base.is_grounded()
