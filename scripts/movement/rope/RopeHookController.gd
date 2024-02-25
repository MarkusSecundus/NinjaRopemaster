extends RigidBody2D
class_name RopeHookController

signal on_hit();

var is_frozen : bool = false
var frozen_position : Vector2;
var is_finished : bool = false;

func _on_hitting_target(target: Node)->void:
	if is_finished: return
	#dprint("Hook hit something ({0})".format([name]))
	is_frozen=true
	frozen_position = global_position
	on_hit.emit()

func _integrate_forces(state):
	if !is_frozen: return
	linear_velocity = Vector2.ZERO
	global_position = frozen_position
