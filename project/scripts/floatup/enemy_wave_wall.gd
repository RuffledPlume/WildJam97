extends Node2D

var canvas_layer : CanvasLayer

func _ready() -> void:
	canvas_layer = get_tree().get_first_node_in_group("CanvasLayer")

	
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		body.disable_input()
		on_player_died()

func on_player_died() -> void:
	canvas_layer.death_screen()
