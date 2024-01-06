# Simple movement and jump
# Wrapping around the edges of the screen

extends CharacterBody2D

@export var speed: int = 400
@export var jump_force: int = 750

@export var jump_press_tolerance_seconds : float = 0.3

# Set the gravity from project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2


func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_pressed("Left"):
		move_left()
	elif Input.is_action_pressed("Right"):
		move_right()
	else:
		move_stop()
		
	handle_jumping(Input.is_action_just_pressed("Jump"))
	
	move_and_slide()
	ScreenWrap.wrap_x_cbody(self)
		

func move_left():
	velocity.x = -speed
	$Sprite2D.flip_h = true  # face left
	
func move_right():
	velocity.x = speed
	$Sprite2D.flip_h = false  # face right
	
func move_stop():
	velocity.x = 0
	
var _last_jump_request_end : float = -INF
func handle_jumping(jump_was_requested : bool)->void:
	if is_grounded():
		if jump_was_requested || (_last_jump_request_end > TimeUtils.seconds_elapsed):
			_last_jump_request_end = -INF
			velocity.y = -jump_force
	elif jump_was_requested:
		_last_jump_request_end = TimeUtils.seconds_elapsed + jump_press_tolerance_seconds
	


@onready var _feet : GroundChecker = $Feet;
func is_grounded()->bool:
	return _feet.is_grounded()
