extends RigidBody2D

signal on_hit();

func _on_hitting_target(target: Node)->void:
	print("Hook hit something")
	freeze = true
	on_hit.emit()
