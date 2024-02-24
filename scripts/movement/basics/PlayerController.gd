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

@onready var current_state : IControlState

@onready var _to_rotate : Node2D = $ToRotate;
@onready var _hand : Node2D = $ToRotate/Hand;
@onready var _hand_joint : Joint2D = $JointHolder/PinJoint2D;


class IControlState:
	extends Resource
	
	var base_controller : PlayerController

	func initialize(baseController: PlayerController): self.base_controller = baseController
	func activate()->void: pass
	func deactivate()->void: pass
	func physics_process(delta: float)->void: pass #InterfaceUtils.report_not_implemented_error(physics_process)
	func integrate_forces(state: PhysicsDirectBodyState2D)->void: pass#InterfaceUtils.report_not_implemented_error(integrate_forces)

func _ready():
	state_basic.initialize(self)
	state_climbingrope.initialize(self)
	current_state = self.change_state(state_basic)

func change_state(new_state: IControlState)->IControlState:
	if current_state:
		current_state.deactivate()
	current_state = new_state
	if current_state:
		current_state.activate()
	return current_state

func _physics_process(delta: float)->void:
	if current_state:
		current_state.physics_process(delta)
		
func _integrate_forces(state: PhysicsDirectBodyState2D)->void:
	if current_state:
		current_state.integrate_forces(state)
		

func is_grounded()->bool:
	return _feet.is_grounded()
