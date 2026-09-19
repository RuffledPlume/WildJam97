class_name ArcadeMachine extends Interactable

@export var camera : Camera3D

var is_player_using : bool
var is_complete : bool

func can_interact_with() -> bool:
	return !is_player_using && !is_complete
	
func on_interact_with_pressed() -> void:
	is_player_using = true
	MainPlayer.INSTANCE.is_locked = true
	camera.make_current()
