# Simple movement and jump
# Wrapping around the edges of the screen

extends "res://scripts/ScreenWrap.gd"  # the player can wrap around the edges of the screen

export(int) var speed = 400
export(int) var jump_force = 750

	
# Correct way of changing RigidBody's position or velocity is in the _integrate_forces method
#	- changing directly the physics state
func _integrate_forces(state):
	if Input.is_action_pressed("Left"):
		move_left(state)
	elif Input.is_action_pressed("Right"):
		move_right(state)
	else:
		move_stop(state)
		
	if Input.is_action_just_pressed("Jump"):
		jump(state)
		
	screen_wrap(state)
		

func move_left(state):
	state.linear_velocity.x = -speed
	$Sprite.flip_h = true  # face left
	
func move_right(state):
	state.linear_velocity.x = speed
	$Sprite.flip_h = false  # face right
	
func move_stop(state):
	state.linear_velocity.x = 0
	
func jump(state):
	state.linear_velocity.y = -jump_force
