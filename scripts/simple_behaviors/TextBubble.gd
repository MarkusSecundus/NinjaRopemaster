extends Node

@export_multiline var message: String = "";


func _on_body_enter(body: Node):
	if body is PlayerController:
		pass
	
func _on_body_exit(body: Node):
	if body is PlayerController:
		pass
