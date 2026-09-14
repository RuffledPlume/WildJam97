extends Node

@export var insert_coin_text : Label
@export var insert_coin_flash_speed := 0.5

func _process(delta: float) -> void:
	var insert_coin_text_color := insert_coin_text.modulate
	insert_coin_text_color.a = pingpong(Time.get_ticks_msec(), insert_coin_flash_speed) / insert_coin_flash_speed
	insert_coin_text.modulate = insert_coin_text_color
