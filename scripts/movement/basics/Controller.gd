# Simple movement and jump
# Wrapping around the edges of the screen

extends CharacterBody2D
class_name PlayerController

# Set the gravity from project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2

@onready var _feet : GroundChecker = $Feet;
@onready var _sprite : Sprite2D = $Sprite2D

@export var State_Basic : BasicControlState
@export var State_ClimbingRope : ClimbingRopeControlState

@onready var CurrentState : IControlState = self._change_state(State_Basic)

class IControlState:
	extends Resource
	
	var base_controller : PlayerController

	func activate()->void: pass
	func deactivate()->void: pass
	func physics_process(delta: float)->void: InterfaceUtils.report_not_implemented_error(physics_process)


func _change_state(new_state: IControlState)->IControlState:
	print("changing state to {0} ({1}, {2})".format([new_state, State_Basic, State_ClimbingRope]))
	if CurrentState:
		CurrentState.deactivate()
	CurrentState = new_state
	if CurrentState:
		CurrentState.base_controller = self
		CurrentState.activate()
	return CurrentState

func _physics_process(delta):
	if CurrentState:
		CurrentState.physics_process(delta)
		
		

func is_grounded()->bool:
	return _feet.is_grounded()
