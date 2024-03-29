extends Node


var tweens : Array[CustomTween] = []  # all active tweens


func _process(delta):
	var i :int= 0
	# update all active tweens, remove the finished ones
	while i < len(tweens):
		if _try_remove_tween(tweens[i], i): continue # remove the tween if it was stopped manually by the user
		i += 1
	i = 0
	while i < len(tweens):
		tweens[i].update(delta)
		i += 1
	i = 0
	while i < len(tweens):
		if _try_remove_tween(tweens[i], i): continue # remove the tween if it just finished
		i += 1

func _try_remove_tween(tween:CustomTween, index:int)->bool:
		if tween.is_done():
			tweens.pop_at(index)
			if tween._on_finish_callback && tween._on_finish_callback.get_object(): #without the last condition, gd would sometimes randomly crash ("attempt to call function on null instance")
				tween._on_finish_callback.call(tween)
			return true
		return false

func tween(target_obj, target_property_name, start_value, end_value, duration, ease_type:Callable=EaseType.LINEAR, on_finish_callback: Callable=Callable())->CustomTween:  # (t: CustomTween) => void
	var tween = CustomTween.new(target_obj, target_property_name,start_value, end_value, duration, ease_type, on_finish_callback)
	tweens.append(tween)
	return tween
