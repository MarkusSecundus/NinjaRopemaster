extends Node

@export var stream: AudioStream;

func play()->void:
	SoundManager.PlaySound(stream)
