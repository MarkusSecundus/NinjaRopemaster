extends Object
class_name CoroutineUtils


static func wait_for_seconds(this: Node, seconds: float):
	return this.get_tree().create_timer(seconds).timeout;

static func forget_and_fire_after_seconds(this: Node, seconds: float, callback: Callable):
	await wait_for_seconds(this, seconds);
	callback.call()
