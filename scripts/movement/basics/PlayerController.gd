# Simple movement and jump
# Wrapping around the edges of the screen

extends RigidBody2D
class_name PlayerController

# Set the gravity from project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2

@onready var _feet : GroundChecker = $Feet;
@onready var _sprite : Sprite2D = $Sprite2D

@export var state_basic : BasicControlState
@export var state_climbingrope : ClimbingRopeControlState

@onready var current_state : IControlState = self.change_state(state_basic)

class IControlState:
	extends Resource
	
	var base_controller : PlayerController

	func activate()->void: pass
	func deactivate()->void: pass
	func physics_process(delta: float)->void: InterfaceUtils.report_not_implemented_error(physics_process)


func change_state(new_state: IControlState)->IControlState:
	if current_state:
		current_state.deactivate()
	current_state = new_state
	if current_state:
		current_state.base_controller = self
		current_state.activate()
	return current_state

func _physics_process(delta):
	if current_state:
		current_state.physics_process(delta)
		
		

func is_grounded()->bool:
	return _feet.is_grounded()
