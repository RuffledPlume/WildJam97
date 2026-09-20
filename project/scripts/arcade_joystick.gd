extends Node

@export var arcade : ArcadeMachine
@export var pivot : Node3D
@export var max_rotation := 30.0

var target_axis : Vector2

func _process(_delta: float) -> void:
	var axis := arcade.get_vector("platformer_player_right", "platformer_player_left", "platformer_player_jump", "platformer_player_drop")
	target_axis.x = move_toward(target_axis.x, axis.x, _delta * 5.5)
	target_axis.y = move_toward(target_axis.y, axis.y, _delta * 5.5)
	
	pivot.rotation.x = deg_to_rad(max_rotation * target_axis.y)
	pivot.rotation.z = deg_to_rad(max_rotation * target_axis.x)
