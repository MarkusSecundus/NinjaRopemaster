extends Node
class_name PlaySound

@export var stream: AudioStream;
@export var pitch_min : float = 1
@export var pitch_max : float = 1
@export var volume_db : float = 0

@export var play_period_seconds : float = 0.5

var _periodical_play_id : int = 0;
func start_periodical_play()->void:
	_periodical_play_id += 1
	var play_id = _periodical_play_id
	while play_id == _periodical_play_id:
		play()
		await CoroutineUtils.wait_for_seconds(self, play_period_seconds)

func stop_periodical_play()->void:
	_periodical_play_id += 1


func play()->void:
	SoundManager.PlaySound(stream, randf_range(pitch_min, pitch_max) if pitch_min < pitch_max else pitch_min, volume_db)
