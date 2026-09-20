extends AnimatableBody3D

@export var move_axis : Vector3 = Vector3.RIGHT
@export var min_offset : float = -2.0
@export var max_offset : float = 2.0

var start_position : Vector3

func _ready() -> void:
	start_position = global_position
	add_to_group("moveable")
	input_event.connect(MouseHandler._on_block_input_event.bind(self))
	
func reset() -> void:
	global_position = start_position
