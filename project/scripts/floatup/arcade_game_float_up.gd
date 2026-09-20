extends CanvasLayer

@export var arcade : ArcadeMachine

signal start_flying
signal drop_key
signal new_sky

var game_started : bool = false
var player : CharacterBody2D
var key    : Node2D
var menu_finished : bool = false
var menu_array    : Array[CanvasLayer]
var idx           : int
var current_page  : CanvasLayer
var chosen_sprite : AnimatedSprite2D

@onready var title_page: CanvasLayer = %TitlePage
@onready var how_to_page: CanvasLayer = %HowToPage
@onready var enemies_page: CanvasLayer = %EnemiesPage
@onready var powerup_page: CanvasLayer = %PowerupPage

@onready var ui: Control = %UI
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var anim_player_mountain: AnimationPlayer = %AnimPlayerMountain
@onready var anim_player_sky: AnimationPlayer = %AnimPlayerSky
@onready var anim_player_key: AnimationPlayer = %AnimPlayerKey
@onready var anim_player_win_label: AnimationPlayer = %AnimPlayerWinLabel
@onready var anim_player_enemy_wave: AnimationPlayer = %AnimPlayerEnemyWave
@onready var anim_player_death_screen: AnimationPlayer = %AnimPlayerDeathScreen
@onready var spawn_manager: Node2D = %SpawnManager
@onready var e_label: Label = %Label


func _ready() -> void:
	animation_player.play("turn_on")
	player = get_tree().get_first_node_in_group("Player")
	player.set_physics_process(false)
	player.player_died.connect(death_screen)
	spawn_manager.initialise_end_game.connect(remove_sky)
	key = get_tree().get_first_node_in_group("Key")
	key.key_collected.connect(drop_win_label)
	
	menu_array.append(title_page)
	menu_array.append(how_to_page)
	menu_array.append(enemies_page)
	menu_array.append(powerup_page)
	
	current_page = title_page

func _process(delta: float) -> void:
	if menu_finished || !arcade.is_player_using:
		return
		
	if (idx == 0 || Input.is_action_just_pressed("enter")) and not menu_finished:
		if idx < menu_array.size() - 1:      # Check if current idx is less than menu_array size
			menu_array[idx].visible = false  # Set current menu_array page to invisible
			idx += 1                         # Add 1 to the idx so it moves from 0 > 1 > 2 > 3 each time
			menu_array[idx].visible = true   # Set new menu_array page to visbile
		else:							     # Loop until idx is = to menu_array.size()
			menu_array[idx].visible = false  # On the last page, start the game
			menu_finished = true
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

func death_screen() -> void:
	anim_player_death_screen.play("display_death_screen")
	spawn_manager.end_game = true
	await get_tree().create_timer(9.0).timeout
	get_tree().reload_current_scene()
	
	
func handle_animations() -> void:
	anim_player_enemy_wave.play("move_wall")
	anim_player_mountain.play("scroll_mountains")
	anim_player_sky.play("scroll_sky")

func remove_sky() -> void:
	anim_player_sky.play("remove_sky")
	final_scene()
	for h in get_tree().get_nodes_in_group("Hazard"):
		h.queue_free()

# FIND WHERE TO CALL THIS 
func final_scene() -> void:
	anim_player_enemy_wave.stop()
	anim_player_enemy_wave.play("remove_wave")
	anim_player_sky.play("new_sky")
	await get_tree().create_timer(2.0).timeout
	anim_player_key.play("drop_key")
	await get_tree().create_timer(1.0).timeout
	anim_player_sky.play("new_ground")
	player.is_flying = false
	ui.visible = false

func drop_win_label() -> void:
	anim_player_win_label.play("drop_win_label")
	anim_player_key.play("you_win")
