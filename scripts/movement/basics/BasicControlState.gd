class_name BasicControlState
extends PlayerController.IControlState


@export var speed: int = 400
@export var jump_force: int = 750

@export var jump_press_tolerance_seconds : float = 0.3

var base : CharacterBody2D:
	get: return base_controller as CharacterBody2D

func physics_process(delta):
	if not base.is_on_floor():
		base.velocity.y += base.gravity * delta

	if Input.is_action_pressed("Left"):
		move_left()
	elif Input.is_action_pressed("Right"):
		move_right()
	else:
		move_stop()
		
	handle_jumping(Input.is_action_just_pressed("Jump"))
	
	base.move_and_slide()
	ScreenWrap.wrap_x_cbody(base)
		

func move_left():
	var p : PhysicsBody2D = null
	base.velocity.x = -speed
	base._sprite.flip_h = true  # face left
	
func move_right():
	base.velocity.x = speed
	base._sprite.flip_h = false  # face right
	
func move_stop():
	base.velocity.x = 0
	
var _last_jump_request_end : float = -INF
func handle_jumping(jump_was_requested : bool)->void:
	if is_grounded():
		if jump_was_requested || (_last_jump_request_end > TimeUtils.seconds_elapsed):
			_last_jump_request_end = -INF
			base.velocity.y = -jump_force
	elif jump_was_requested:
		_last_jump_request_end = TimeUtils.seconds_elapsed + jump_press_tolerance_seconds
	


func is_grounded()->bool:
	return base._feet.is_grounded()
