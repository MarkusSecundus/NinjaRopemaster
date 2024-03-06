# Simple movement and jump
# Wrapping around the edges of the screen

extends RigidBody2D
class_name PlayerController

# Set the gravity from project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2

@onready var _sprite : Sprite2D = $Sprite2D

@export var state_basic : BasicControlState
@export var state_climbingrope : ClimbingRopeControlState

@onready var current_state : IControlState

@onready var _to_rotate : Node2D = $ToRotate;
@onready var _hand : Node2D = $ToRotate/Hand;
@onready var _hand_joint : Joint2D = $JointHolder/PinJoint2D;

@onready var _respawner : IRespawnable = NodeUtils.get_child_of_type(self, IRespawnable)
@onready var _animator : AnimationPlayer = $AnimationPlayer;

signal on_jump();

class IControlState:
	extends Resource
	
	var base_controller : PlayerController

	func initialize(baseController: PlayerController): self.base_controller = baseController
	func activate()->void: pass
	func deactivate()->void: pass
	func physics_process(delta: float)->void: pass #InterfaceUtils.report_not_implemented_error(physics_process)
	func integrate_forces(state: PhysicsDirectBodyState2D)->void: pass#InterfaceUtils.report_not_implemented_error(integrate_forces)
	func process(delta: float)->void: pass

func _ready():
	if state_basic: state_basic.initialize(self)
	if state_climbingrope: state_climbingrope.initialize(self)
	reset()


func do_die():
	current_state = self.change_state(null)
	_animator.play("Die")

func reset():
	print("reseting the player")
	if _respawner.is_respawn_point_set(): _respawner.respawn()
	_animator.play("Idle")
	current_state = self.change_state(state_basic)

func change_state(new_state: IControlState)->IControlState:
	if current_state: current_state.deactivate()
	current_state = new_state
	if current_state: current_state.activate()
	return current_state

func _physics_process(delta: float)->void:
	if current_state: current_state.physics_process(delta)
	StatsTracker._update_player_record_stats(self)
		
func _process(delta)->void:
	if current_state: current_state.process(delta)
	
var last_velocity : Vector2;	
func _integrate_forces(state: PhysicsDirectBodyState2D)->void:
	#var original_velocity = state.linear_velocity
	#print("velocity: {0}".format([state.linear_velocity]))
	#if state.linear_velocity.abs().x < 0.1 && last_velocity.abs().x > 60:
	#	state.linear_velocity = last_velocity
	#	state.linear_velocity.y += -1
	#	print("velocity helper")
	#last_velocity = original_velocity
	
	if current_state:
		current_state.integrate_forces(state)
		

@onready var _feet : GroundChecker = $Feet;
func is_grounded()->bool:
	return _feet.is_grounded()

@onready var _freefallChecker : GroundChecker = $FreefallDetector
func is_in_freefall()->bool:
	return !_freefallChecker.is_grounded()
