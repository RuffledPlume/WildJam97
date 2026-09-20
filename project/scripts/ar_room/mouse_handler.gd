extends Node3D

var held_block : Node3D
var grab_point : Vector3


func _on_block_input_event(camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int, block: Node3D) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			held_block = block
			grab_point = event_position

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			held_block = null
			
func _physics_process(_delta: float) -> void:
	if held_block == null:
		return
	var camera    := get_viewport().get_camera_3d()
	var mouse_pos := get_viewport().get_mouse_position()
	var from      := camera.project_ray_origin(mouse_pos)
	var to        := from + camera.project_ray_normal(mouse_pos) * 1000.0
	var axis_from : Vector3 = held_block.global_position - held_block.move_axis * 100.0
	var axis_to   : Vector3 = held_block.global_position + held_block.move_axis * 100.0
	var points    := Geometry3D.get_closest_points_between_segments(from, to, axis_from, axis_to)
	var offset    : float = (points[1] - held_block.start_position).dot(held_block.move_axis)
	offset = clamp(offset, held_block.min_offset, held_block.max_offset)
	held_block.global_position = held_block.start_position + held_block.move_axis * offset
