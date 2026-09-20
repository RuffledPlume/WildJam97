class_name ArcadeMachine extends Interactable

@export var camera : Camera3D
@export var game_prefab : PackedScene
@export var game_viewport : SubViewport
@export var screen : ArcadeScreen

var is_player_using : bool
var game_instance : Node

func _ready() -> void:
	game_instance = game_viewport.get_child(0)
	
func _process(_delta : float) -> void:
	var input_dir = Input.get_vector("main_player_move_left", "main_player_move_right", "main_player_move_forward", "main_player_move_back")
	if !input_dir.is_zero_approx():
		is_player_using = false
		MainPlayer.INSTANCE.is_locked = false
		MainPlayer.INSTANCE.camera.make_current()
	
func can_interact_with() -> bool:
	return !is_player_using
	
func get_interact_label_position() -> Vector3:	
	return screen.global_position

func on_interact_with_pressed() -> void:
	is_player_using = true
	MainPlayer.INSTANCE.is_locked = true
	camera.make_current()
	
func restart() -> void:
	if game_instance != null:
		game_viewport.remove_child(game_instance)
		game_instance.queue_free()
	game_instance = game_prefab.instantiate()
	game_viewport.add_child(game_instance)

func is_anything_pressed() -> bool:
	return is_player_using && Input.is_anything_pressed()
	
func is_action_pressed(action : String) -> bool:
	return is_player_using && Input.is_action_pressed(action)
	
func is_action_just_pressed(action : String) -> bool:
	return is_player_using && Input.is_action_just_pressed(action)
	
func is_action_just_released(action : String) -> bool:
	return is_player_using && Input.is_action_just_released(action)
	
func get_axis(negative_action : String, positive_action : String) -> float:
	return is_player_using && Input.get_axis(negative_action, positive_action)
