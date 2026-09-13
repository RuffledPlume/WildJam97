extends CanvasLayer

signal start_flying

var game_started : bool = false
var player : CharacterBody2D

@onready var title_page: CanvasLayer = %TitlePage

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	player.set_physics_process(false)
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("enter") and not game_started:
		game_started = true
		title_page.visible = false
		player.set_physics_process(true)

func initialise_flying() -> void:
	# Start flying is initialised by lighting the camp fire in fire.gd
	start_flying.emit()
