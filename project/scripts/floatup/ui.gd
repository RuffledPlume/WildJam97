extends Control

var player : CharacterBody2D
@onready var heart_icon: TextureRect = $HBoxContainer/HeartIcon
@onready var heart_icon_2: TextureRect = $HBoxContainer/HeartIcon2
@onready var heart_icon_3: TextureRect = $HBoxContainer/HeartIcon3
@onready var shrink_icon: TextureRect = $HBoxContainer2/ShrinkIcon
@onready var steer_icon: TextureRect = $HBoxContainer2/SteerIcon
@onready var shrink_timer: Timer = %ShrinkTimer
@onready var steer_timer: Timer = %SteerTimer


func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	player.health_changed.connect(handle_hearts)
	player.shrinked.connect(display_shrink_icon)
	player.steering.connect(display_steer_icon)
	shrink_timer.timeout.connect(hide_shrink_icon)
	steer_timer.timeout.connect(hide_steer_icon)
	
func handle_hearts() -> void:
	if player.health == 3:
		return
	if player.health == 2:
		heart_icon_3.visible = false
	if player.health == 1:
		heart_icon_2.visible = false
	if player.health == 0:
		heart_icon.visible = false
	
func display_shrink_icon() -> void:
	shrink_icon.visible = true

func display_steer_icon() -> void:
	steer_icon.visible = true

func hide_shrink_icon() -> void:
	shrink_icon.visible = false

func hide_steer_icon() -> void:
	steer_icon.visible = false
	
