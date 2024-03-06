extends Node
class_name PlaySound

@export var stream: AudioStream;
@export var stream_variants: Array[AudioStream]
@export var pitch_min : float = 1
@export var pitch_max : float = 1
@export var volume_db : float = 0

@export var play_period_seconds : float = 0.5
@export var immediate_stop_duration_seconds: float = 0.2;

var _periodical_play_id : int = 0;
func start_periodical_play()->void:
	if play_period_seconds <= 0: play_period_seconds = stream.get_length()
	_periodical_play_id += 1
	var play_id = _periodical_play_id
	while play_id == _periodical_play_id:
		play()
		await CoroutineUtils.wait_for_seconds(self, play_period_seconds)

func stop_periodical_play()->void:
	_periodical_play_id += 1

func stop_periodical_play_immediate()->void:
	stop_periodical_play()
	if _current_player && _current_player.playing && (TimeUtils.seconds_elapsed < _last_play_timestamp + stream.get_length()):
		SoundManager.StopPlayGradually(_current_player, immediate_stop_duration_seconds)

var _current_player : AudioStreamPlayer;
var _last_play_timestamp : float = -INF;
func play()->void:
	var to_play: AudioStream = stream if stream_variants.size() <=0 else stream_variants.pick_random();
		
	_last_play_timestamp = TimeUtils.seconds_elapsed
	_current_player = SoundManager.PlaySound(to_play, randf_range(pitch_min, pitch_max) if pitch_min < pitch_max else pitch_min, volume_db)
