extends Object
class_name CoroutineUtils


class TweenWrapper:
	var value : Tween;
	var host_node : Node;
	func _init(host, value=null): 
		self.host_node = host
		self.value = value


static func wait_for_seconds(this: Node, seconds: float):
	return this.get_tree().create_timer(seconds).timeout;

static func forget_and_fire_after_seconds(this: Node, seconds: float, callback: Callable):
	await wait_for_seconds(this, seconds);
	callback.call()

static func do_tween_transition(tweener: TweenWrapper, make_begin_tween : Callable, action_in_middle: Callable, middle_wait: float, make_end_tween : Callable, cleanup_action: Callable=Callable()):
	if tweener.value && tweener.value.is_running():
		tweener.value.stop()
	tweener.value = tweener.host_node.create_tween();
	if make_begin_tween: make_begin_tween.call(tweener.value);
	if action_in_middle: tweener.value.tween_callback(action_in_middle);
	if middle_wait > 0: tweener.value.tween_interval(middle_wait)
	if make_end_tween: make_end_tween.call(tweener.value);
	if cleanup_action: tweener.value.tween_callback(cleanup_action)
	pass
