class_name CustomTween


const BEGIN := 0.0;
const TARGET := 1.0;
var t := 0.0
var tween_speed := 1.0;

var start_value;
var end_value;

var target_obj;
var target_property_name;
var ease_type : Callable;
var _on_finish_callback := Callable();

func _init(target_obj, target_property_name, start_value, end_value, duration, ease_type:Callable, on_finish_callback : Callable):
	self.t = BEGIN
	self.tween_speed = (TARGET-BEGIN)/duration
	self.start_value = start_value
	self.end_value = end_value
	self.target_obj = target_obj
	self.target_property_name = target_property_name
	self.ease_type = ease_type
	self.add_on_finished_callback(on_finish_callback);


func update(delta: float):
	if _is_done: return 
	
	t = min(TARGET, t + delta*tween_speed);
	if t >= TARGET:
		_is_done = true;
	
	var to_set = lerp(start_value, end_value, ease_type.call(t));
	target_obj.set(target_property_name, to_set)

func add_on_finished_callback(on_finish_callback:Callable)->CustomTween:
	if !self._on_finish_callback:
		self._on_finish_callback = on_finish_callback;
	else:
		var old = self._on_finish_callback
		self._on_finish_callback = func(t:CustomTween):
			old.call(t)
			on_finish_callback.call(t)
	return self

var _is_done := false;
func is_done() -> bool:
	return _is_done;

func then_to(new_end_value, duration:float, ease_type:Callable = Callable())->CustomTween:
	var chained_tween = CustomTween.new(self.target_obj, self.target_property_name, self.end_value, new_end_value, duration, ease_type if ease_type else self.ease_type, Callable())
	self.add_on_finished_callback(func(t): Tweens.tweens.append(chained_tween))
	return chained_tween
