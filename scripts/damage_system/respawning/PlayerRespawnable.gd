extends IRespawnable
class_name PlayerRespawnable


@onready var _player := NodeUtils.get_ancestor_of_type(self, PlayerController) as PlayerController
@onready var _damageable := NodeUtils.get_sibling_of_type(self, Damageable) as Damageable 


func is_respawn_point_set()->bool: return _respawn_point != null

var _respawn_point : Node2D;
func set_respawn_point(point: Node2D)->void: 
	_respawn_point = point
	print("setting respawn to {0}..{1}".format([point, _get_respawn_position()]))

func _get_respawn_position()->Vector2: return _respawn_point.global_position if _respawn_point else Vector2.ZERO

func respawn()->void: 
	print("respawning {0} -> {1}".format([_player.global_position, _get_respawn_position()]))
	StatsTracker.deaths_count += 1
	_player.global_position = _get_respawn_position()
	if _damageable: _damageable.reset()
