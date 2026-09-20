class_name FocusableWidget extends Control

@export var focused_modulate := Color.BISQUE
@export var normal_modulate := Color.WHITE

var _arcade : ArcadeMachine
var _is_focused : bool

func focus_changed(_focused : bool) -> void:
	if !_focused:
		modulate = normal_modulate
	_is_focused = _focused
		
func _process(delta: float) -> void:
	if _is_focused:
		modulate = lerp(normal_modulate, focused_modulate, pingpong(Time.get_ticks_msec(), 3.0))
