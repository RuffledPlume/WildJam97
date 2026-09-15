extends Node2D

var picked_up = false

@onready var pick_up = %pick_up1
@onready var locked_door = %locked_door
@onready var press_to_start = %press2start
@onready var two_way_platform = %two_way_platform
@onready var foreground_layer = %foreground

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
	if Input.is_action_just_pressed("platformer_player_interact") and picked_up == true:
		locked_door.play("open")
	else:
		pass
	
	if Input.is_action_just_pressed("platformer_player_drop"):
		two_way_platform.collision_enabled = false
	elif Input.is_action_just_released("platformer_player_drop"):
		two_way_platform.collision_enabled = true

func foreground_on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		create_tween().tween_property(foreground_layer, "modulate:a", .2, .5)


func foreground_on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		create_tween().tween_property(foreground_layer, "modulate:a", 1, .5)
