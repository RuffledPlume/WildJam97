class_name ArcadeMachine extends Interactable

@export var camera : Camera3D
@export var game_prefab : PackedScene
@export var game_viewport : SubViewport

var is_player_using : bool
var game_instance : Node2D

func _ready() -> void:
	game_instance = game_viewport.get_child(0)

func can_interact_with() -> bool:
	return !is_player_using
	
func on_interact_with_pressed() -> void:
	is_player_using = true
	MainPlayer.INSTANCE.is_locked = true
	camera.make_current()
	
func restart() -> void:
	game_instance.queue_free()
	game_instance = game_prefab.instantiate()
	game_viewport.add_child(game_instance)
