extends Node2D

var picked_up = false
var door_area_active = false

@onready var pick_up = %pick_up
@onready var locked_door = %locked_door
@onready var press_to_start = %press2start

func start_game():
	if Input.is_anything_pressed() and press_to_start.visible == true:
		press_to_start.visible = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	press_to_start.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	start_game()

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("platformer_player_interact") and door_area_active == true and picked_up == true:
		locked_door.play("open")
	else:
		pass

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	picked_up = true
	pick_up.visible = false

func door_on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	door_area_active = true

func door_on_area_2d_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	door_area_active = false
