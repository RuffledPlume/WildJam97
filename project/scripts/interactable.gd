class_name Interactable extends StaticBody3D

func get_interact_label_position() -> Vector3:
	return global_position

func get_interact_text() -> String:
	return ""

func can_interact_with() -> bool:
	return false

func on_interact_with_pressed() -> void:
	pass
	
func on_interact_with_held() -> void:
	pass
	
func on_interact_with_released() -> void:
	pass
