extends Node

@export var arcade : ArcadeMachine
@export var widgets : Array[FocusableWidget]

var _widget_idx := -1

func _ready() -> void:
	for widget in widgets:
		widget._arcade = arcade
	_focus_widget(0)

func _focus_widget(idx : int) -> void:
	if idx < 0 || idx >= widgets.size():
		return
		
	if idx != _widget_idx:
		if _widget_idx != -1:
			widgets.get(_widget_idx).focus_changed(false)
		_widget_idx = idx
		widgets.get(_widget_idx).focus_changed(true)

func _process(_delta : float) -> void:
	if arcade.is_action_just_pressed("ui_up"):
		_focus_widget(_widget_idx - 1)
	elif arcade.is_action_just_pressed("ui_down"):
		_focus_widget(_widget_idx + 1)
