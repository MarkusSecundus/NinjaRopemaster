extends Node


@export_multiline var _format : String = """Stats...
   Finish time: {0} s
   Deaths: {1}
   Ropes shot: {2}
   Rope jumps: {6}
   Max velocity: {7} m/s 
""";

@export var points_to_meters_convertion_ratio = 1.0/100;

var _first_showup_time_seconds : float = NAN;
var _is_first_showup: bool:
	get: return is_nan(_first_showup_time_seconds)
var _sign : TextBubble;

func _ready():
	_sign = NodeUtils.get_ancestor_of_type(self, TextBubble) as TextBubble
	if _format.is_empty(): _format = _sign.message
	_sign.on_show.connect(func():
		if _is_first_showup:
			_first_showup_time_seconds = TimeUtils.seconds_elapsed
		_sign.message = _format.format([
			"%.2f"%[_first_showup_time_seconds], StatsTracker.deaths_count, 
			StatsTracker.ropes_shot_total, StatsTracker.ropes_shot_successful, StatsTracker.ropes_shot_unsuccessful, 
			StatsTracker.jump_count, StatsTracker.rope_jump_count,
			"%.2f"%[StatsTracker.max_achieved_velocity * points_to_meters_convertion_ratio]
		]);
		print("(time: {0} -> {1})setting message to:\n{2}".format([TimeUtils.seconds_elapsed,_first_showup_time_seconds, _sign.message]))
	);

