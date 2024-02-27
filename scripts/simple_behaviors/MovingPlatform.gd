extends Node2D
class_name MovingPlatform

@export var movement_speed: float = 200;
@onready var _platform := $Platform

@export var movement_type := MovementType.Cyclic;
enum MovementType{Cyclic, Return}
class CyclicIndexer:
	extends CoroutineUtils.Generator
	func _impl(index_count:int)->void:
		var i :int= 0;
		while true:
			await _yield(i)
			i = (i+1)%index_count
class ReturnIndexer:
	extends CoroutineUtils.Generator
	func _impl(index_count: int)->void:
		var i: int=0;
		while true:
			while i < index_count:
				await _yield(i)
				i += 1
			i -= 1
			while i > 0:
				i -= 1
				await _yield(i)
			i += 1
func _get_indexer_type(type: MovementType): 
	match type:
		MovementType.Cyclic: return CyclicIndexer
		MovementType.Return: return ReturnIndexer


func _ready():
	if get_child_count() <= 1:
		ErrorUtils.report_error("MovingPlatform {0} must have at least one explicit child child!".format([name]))
		return
	var indexer = _get_indexer_type(movement_type).new([get_child_count()])
	indexer.MoveNext()
	_move_next(indexer)

func _get_segment_position(index: int)->Vector2: return Vector2.ZERO if index==0 else (get_child(index, true) as Node2D).position


func _move_next(indexer: CoroutineUtils.Generator)->void:
	var begin_index := indexer.Current as int;
	indexer.MoveNext()
	var end_index := indexer.Current as int;
	var begin := _get_segment_position(begin_index)
	var end := _get_segment_position(end_index)
	var duration := end.distance_to(begin)/movement_speed
	
	Tweens.tween(_platform, "position", begin, end, duration, EaseType.EASE_IN_BOUNCE, func(t:CustomTween):_move_next(indexer));
