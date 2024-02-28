@tool

extends Node

@export_multiline var message: String = "":
	get: return message
	set(value): 
		message = value
		if Engine.is_editor_hint():
			$CanvasLayer/Bubble/Label.text = message
			
@export var fade_seconds : float = 0.2;
@export var __editor_bubble_visible:bool = false:
	get: return __editor_bubble_visible
	set(value):
		__editor_bubble_visible = value
		if Engine.is_editor_hint():
			if value:$CanvasLayer.show()
			else:$CanvasLayer.hide()

@onready var _canvasLayer := $CanvasLayer
@onready var _bubble := $CanvasLayer/Bubble;

func _ready():
	if Engine.is_editor_hint(): return
	$CanvasLayer/Bubble/Label.text = message
	_canvasLayer.hide()
	_bubble.modulate = Color(_bubble.modulate, 0.0)


var _tween :CustomTween; 
func _tween_fade(alpha: float)->CustomTween:
	if _tween: _tween.stop()
	var original_modulate := _bubble.modulate as Color
	_tween = Tweens.tween(_bubble, "modulate", original_modulate, Color(original_modulate, alpha), fade_seconds);
	return _tween


var _should_be_visible : bool = false;

func _on_body_enter(body: Node):
	if body is PlayerController:
		print("player entered")
		_should_be_visible = true;
		_canvasLayer.show()
		_tween_fade(1.0)
	
func _on_body_exit(body: Node):
	if body is PlayerController:
		print("player left")
		_should_be_visible = false
		_tween_fade(0.0).add_on_finished_callback(func(_t):if!_should_be_visible:_canvasLayer.hide())
