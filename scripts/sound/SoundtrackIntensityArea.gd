extends Node

@export var intensity: float = 0;


func _on_body_enter(body: Node)->void:
	if body is PlayerController:
		apply_intensity()

func apply_intensity()->void:
	SoundManager.SetSoundtrackIntensity(intensity)
