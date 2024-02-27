extends Node


@onready var _soundtrackLayers : Node = $SoundtrackLayers
@onready var _soundPool :Node= $SoundPool;



func _get_sound_player()->AudioStreamPlayer:
	for c in get_children():
		var str := c as AudioStreamPlayer
		if !str.is_playing(): return str
	var ret = AudioStreamPlayback.new();
	_soundPool.add_child(ret);
	return ret;

func PlaySound(sound: AudioStream)->void:
	var player := _get_sound_player()
	player.stream = sound
	player.play()
