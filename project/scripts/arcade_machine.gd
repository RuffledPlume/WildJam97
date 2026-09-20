class_name ArcadeMachine extends Interactable


signal process_input

@export var camera : Camera3D
@export var game_prefab : Node3D

var is_player_using : bool
var is_complete : bool

func can_interact_with() -> bool:
	return !is_player_using && !is_complete
	
func on_interact_with_pressed() -> void:
	is_player_using = true
	MainPlayer.INSTANCE.is_locked = true
	camera.make_current()
	
func restart() -> void:
	pass # TODO: Implement restart functionality for the arcade machine
