extends RigidBody2D
class_name RopeHookController

signal on_hit();

var is_frozen : bool = false
var is_finished : bool = false;

var _attached_body : PhysicsBody2D

var is_attached_to_fixed_body: bool:
	get:
		if not _attached_body: return false
		if _attached_body is RigidBody2D and (not (_attached_body as RigidBody2D).freeze): return false
		return true 

static var _static_helper_body : StaticBody2D = null;

func _exit_tree():
	if _static_helper_body: _static_helper_body.queue_free()

func _on_hitting_target(target: Node)->void:
	if is_finished: return
	#dprint("Hook hit something ({0})".format([name]))
	StatsTracker.ropes_shot_successful += 1
	is_frozen=true
	is_finished = true
	var body = target as PhysicsBody2D
	if !body:
		if not _static_helper_body:
			_static_helper_body = StaticBody2D.new()
			_static_helper_body.name = "StaticHelperBody"
			get_tree().root.add_child(_static_helper_body)
			_static_helper_body.position = Vector2.ZERO
		body = _static_helper_body
	_attached_body = body		
	$Joint.node_b = body.get_path()
	print("Attached to '{0}'".format([body]))
	on_hit.emit()
