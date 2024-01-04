extends Node


var tweens : Array[CustomTween] = []  # all active tweens


func _process(delta):
	var i = 0
	# update all active tweens, remove the finished ones
	while i < len(tweens):
		var tween = tweens[i]
		tween.update(delta)
		if tween.is_done():
			tweens.pop_at(i)
			if tween._on_finish_callback:
				tween._on_finish_callback.call(tween)
		else:
			i += 1


func tween(target_obj, target_property_name, start_value, end_value, duration, ease_type:Callable=EaseType.LINEAR, on_finish_callback: Callable=Callable())->CustomTween:  # (t: CustomTween) => void
	var tween = CustomTween.new(target_obj, target_property_name,start_value, end_value, duration, ease_type, on_finish_callback)
	tweens.append(tween)
	return tween
