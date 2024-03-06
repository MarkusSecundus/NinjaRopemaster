extends Node2D
class_name FancyFade

@export var min_modulate: Color = Color(Color.WHITE, 0)
@export var max_modulate: Color = Color.WHITE
@export var fade_in_seconds: float = 1
@export var fade_out_seconds: float = 1
@export var fade_in_ease : EaseType.Enum = EaseType.Enum.LINEAR
@export var fade_out_ease : EaseType.Enum = EaseType.Enum.LINEAR

@export var action_on_start : ActionOnStart = ActionOnStart.NOTHING

enum ActionOnStart{
	NOTHING=0, FADE_IN, FADE_OUT
}

signal on_automatic_fade_complete()

func _ready():
	match action_on_start:
		ActionOnStart.FADE_IN: fade_in(func():on_automatic_fade_complete.emit())
		ActionOnStart.FADE_OUT: fade_out(func():on_automatic_fade_complete.emit())


func fade_in(on_complete: Callable = Callable())->void:
	_fade_impl(min_modulate, max_modulate, fade_in_seconds, fade_in_ease, on_complete)
	
func fade_out(on_complete: Callable = Callable())->void:
	_fade_impl(max_modulate, min_modulate, fade_in_seconds, fade_out_ease, on_complete)
	
	
var _tw : CustomTween; 
func _fade_impl(start_modulate: Color, end_modulate: Color, duration_seconds: float, ease: EaseType.Enum, on_complete: Callable)->void:
	if _tw && !_tw.is_done(): _tw.stop()
	var ease_func = EaseType.from_enum(ease)
	
	var original_on_complete := on_complete
	var current_tween := DatastructUtils.Wrapper.new(null)
	on_complete = func(_t: CustomTween):
		print("maybe hiding fader %s X %s"%[current_tween, _tw])
		if end_modulate.a <= 0.0 && current_tween.value == _tw: 
			print("hiding fader")
			self.hide()
		original_on_complete.call()
		
	self.modulate = start_modulate
	self.show()
	_tw = Tweens.tween(self, "modulate", start_modulate, end_modulate, duration_seconds, ease_func, on_complete)
	current_tween.value = _tw
