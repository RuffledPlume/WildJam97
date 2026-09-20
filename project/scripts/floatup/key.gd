extends Node2D

signal key_collected

var is_within : bool = false
var player    : CharacterBody2D

@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	animation_player.play("key_star")
	player.interacted.connect(interact)

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_within = true

	
func interact() -> void:
	if is_within:
		key_collected.emit()
		# Play sound
		# Emit signal to drive final title
		queue_free()
