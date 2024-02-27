extends Node


@export var soundtrackTransition_seconds : float = 3.0
@export var minReasonableDb : float = -15.0

@onready var _soundPool :Node= $SoundPool;


const MIN_DB : float= -80.0

var _soundtrackLayers : Array[AudioStreamPlayer] = []
var _soundtrackLayerDefaultIntensities : Array[float] = []
func _ready():
	_soundtrackLayers = NodeUtils.get_children_of_type($SoundtrackLayers, AudioStreamPlayer, _soundtrackLayers) as Array[AudioStreamPlayer];
	_soundtrackLayerDefaultIntensities = CoroutineUtils.Generator.from_array(_soundtrackLayers).select(func(pl:AudioStreamPlayer):return pl.volume_db).to_array(_soundtrackLayerDefaultIntensities);


func _get_sound_player()->AudioStreamPlayer:
	for c in get_children():
		var str := c as AudioStreamPlayer
		if !str.is_playing(): return str
	var ret = AudioStreamPlayback.new();
	_soundPool.add_child(ret);
	return ret;

func PlaySound(sound: AudioStream, pitch: float = 1)->void:
	var player := _get_sound_player()
	player.stream = sound
	player.pitch_scale = pitch
	player.play()


var _running_tweens : Array[CustomTween] = []

func SetSoundtrackIntensity(intensity: float)->void:
	for tw in _running_tweens: tw.stop() 
	_running_tweens.clear()
	
	var i:int = 0
	while i < _soundtrackLayers.size():
		var intensity_factor := clampf(intensity - i, 0, 1) 
		var db := MIN_DB if intensity_factor==0 else lerpf(minReasonableDb, _soundtrackLayerDefaultIntensities[i], intensity_factor)
		var layer := _soundtrackLayers[i]
		if layer.volume_db != db:
			_running_tweens.append(Tweens.tween(layer, "volume_db", layer.volume_db, db, soundtrackTransition_seconds))
		i+= 1
		
