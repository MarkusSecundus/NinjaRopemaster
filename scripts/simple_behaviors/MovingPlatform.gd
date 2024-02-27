extends Node2D


@export var movement_speed: float = 200;

@onready var _platform := $Platform


func _ready():
	if get_child_count() <= 1:
		ErrorUtils.report_error("MovingPlatform {0} must have at least one explicit child child!".format([name]))
		return
	
	_move_next(0, 1)

func _path_segments_count()->int: return get_child_count()
func _get_segment_position(index: int)->Vector2: return Vector2.ZERO if index==0 else (get_child(index, true) as Node2D).position

func _move_next(begin_index: int, end_index: int)->void:
	begin_index %= _path_segments_count()
	end_index %= _path_segments_count()
	var begin := _get_segment_position(begin_index)
	var end := _get_segment_position(end_index)
	var duration := end.distance_to(begin)/movement_speed
	
	Tweens.tween(_platform, "position", begin, end, duration, EaseType.LINEAR, func(t:CustomTween):_move_next(begin_index + 1, end_index + 1));
