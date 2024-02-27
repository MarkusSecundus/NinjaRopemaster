extends Area2D


@onready var _point : Node2D = $SpawnPoint

func _on_entered(body: Node2D)->void:
	var respawnable := NodeUtils.get_child_of_type(body, IRespawnable) as IRespawnable
	if !respawnable: return
	respawnable.set_respawn_point(_point)
