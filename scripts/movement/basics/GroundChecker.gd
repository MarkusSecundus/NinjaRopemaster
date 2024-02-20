extends Area2D
class_name GroundChecker

@export var coyotee_time: float = 0.2

var this: Area2D:
	get: return self

func is_grounded()->bool:
	return self.has_overlapping_bodies() || (TimeUtils.seconds_elapsed - _last_collision_leave_seconds < coyotee_time)


var _last_collision_leave_seconds = -INF

func _on_collision_leave(other: Node)->void:
	print("leaving collision")
	_last_collision_leave_seconds = TimeUtils.seconds_elapsed
