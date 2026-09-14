extends CanvasLayer

signal start_flying
signal drop_key
signal new_sky

var game_started : bool = false
var player : CharacterBody2D

@onready var title_page: CanvasLayer = %TitlePage
@onready var ui: Control = %UI
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var anim_player_mountain: AnimationPlayer = %AnimPlayerMountain
@onready var anim_player_sky: AnimationPlayer = %AnimPlayerSky
@onready var anim_player_key: AnimationPlayer = %AnimPlayerKey
@onready var spawn_manager: Node2D = %SpawnManager
@onready var e_label: Label = %Label


func _ready() -> void:
	animation_player.play("turn_on")
	player = get_tree().get_first_node_in_group("Player")
	player.set_physics_process(false)
	spawn_manager.initialise_end_game.connect(remove_sky)
	
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("enter") and not game_started:
		animation_player.play("remove_scrolling_bg")
		game_started = true
		title_page.visible = false
		e_label.visible = true
		player.set_physics_process(true)
	
func initialise_flying() -> void:
	# Start flying is initialised by lighting the camp fire in fire.gd
	start_flying.emit()
	ui.visible = true
	handle_animations()

func handle_animations() -> void:
	anim_player_mountain.play("scroll_mountains")
	anim_player_sky.play("scroll_sky")

func remove_sky() -> void:
	anim_player_sky.play("remove_sky")
	final_scene()

# FIND WHERE TO CALL THIS 
func final_scene() -> void:
	anim_player_sky.play("new_sky")
	await get_tree().create_timer(2.0).timeout
	anim_player_key.play("drop_key")
	player.is_flying = false
	await get_tree().create_timer(1.0).timeout
	anim_player_sky.play("new_ground")
