extends Node


@export var soundtrackTransition_seconds : float = 3.0
@export var minReasonableDb : float = -15.0

@onready var _soundPool :Node= $SoundPool;


const MIN_DB : float= -80.0

var _soundtrackLayers : Array[SoundtrackPart] = []
func _ready():
	_soundtrackLayers = NodeUtils.get_children_of_type($SoundtrackLayers, SoundtrackPart, _soundtrackLayers) as Array[SoundtrackPart];
	

func _get_sound_player()->AudioStreamPlayer:
	for c in _soundPool.get_children():
		var str := c as AudioStreamPlayer
		if !str.is_playing(): return str
	var ret = AudioStreamPlayer.new();
	_soundPool.add_child(ret);
	return ret;

func PlaySound(sound: AudioStream, pitch: float = 1, volume_db: float=0)->void:
	var player := _get_sound_player()
	player.stream = sound
	player.volume_db = volume_db
	player.pitch_scale = pitch
	player.play()


var _running_tweens : Array[CustomTween] = []

func _compute_intensity(decibel_layers: Array[float], intensity_floor: int, intensity_factor: float)->float:
	if intensity_floor < 0 || decibel_layers.size()<= 1: return decibel_layers[0]
	if intensity_floor+1 >= decibel_layers.size(): return decibel_layers[decibel_layers.size()-1]
	return lerpf(decibel_layers[intensity_floor], decibel_layers[intensity_floor + 1], intensity_factor)

func SetSoundtrackIntensity(intensity: float)->void:
	for tw in _running_tweens: tw.stop() 
	_running_tweens.clear()
	
	var intensity_floor := int(floorf(intensity))
	var intensity_factor := intensity - intensity_floor
	
	var i:int = 0
	while i < _soundtrackLayers.size():
		var layer := _soundtrackLayers[i]
		
		var db := _compute_intensity(layer.decibels, intensity_floor, intensity_factor)
		
		if layer.volume_db != db:
			_running_tweens.append(Tweens.tween(layer, "volume_db", layer.volume_db, db, soundtrackTransition_seconds))
		i+= 1
		
