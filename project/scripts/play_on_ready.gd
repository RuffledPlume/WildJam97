extends Node

@export var player : AnimationPlayer
@export var animation_name : String

func _ready() -> void:
	if player != null && animation_name != null:
		player.play(animation_name)
