extends Node2D

var picked_up1 = false
var picked_up2 = false
var picked_up3 = false

var side_door_locked1_activated = false
var side_door_locked2_activated = false
var locked_door_activated = false
var doorway_activated = false

var locked_door_opened = false

var is_dead = false

@onready var pick_up1 = %pick_up1
@onready var pick_up2 = %pick_up2
@onready var pick_up3 = %pick_up3
@onready var pick_upSkeleton = %pick_up4
@onready var locked_door = %locked_door
@onready var side_door_locked1 = %side_door_locked1
@onready var side_door_locked2 = %side_door_locked2
@onready var side_door1_coll = %side_door1_coll
@onready var side_door2_coll = %side_door2_coll

@onready var platform_player = %player

@onready var two_way_platform = %two_way_platform
@onready var foreground_layer = %foreground

func start_game():
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	start_game()

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("platformer_player_interact") and picked_up1 == true and side_door_locked1_activated == true:
		side_door_locked1.play("open")
		side_door1_coll.disabled = true
	
	if Input.is_action_just_pressed("platformer_player_interact") and picked_up3 == true and side_door_locked2_activated == true:
		side_door_locked2.play("open")
		side_door2_coll.disabled = true
	
	if Input.is_action_just_pressed("platformer_player_interact") and picked_up2 == true and locked_door_activated == true and locked_door_opened == false:
		locked_door.play("open")
		await locked_door.animation_finished
		locked_door_opened = true
	
	if Input.is_action_just_pressed("platformer_player_interact") and locked_door_activated == true and locked_door_opened == true:
		await create_tween().tween_property(platform_player, "modulate:a", 0, .5).finished
		platform_player.position = Vector2(2303.0, -688.0)
		await create_tween().tween_property(platform_player, "modulate:a", 1, .5).finished

	if Input.is_action_just_pressed("platformer_player_interact") and doorway_activated == true and locked_door_opened == true:
		await create_tween().tween_property(platform_player, "modulate:a", 0, .5).finished
		platform_player.position = Vector2(2303.0, -301.0) 
		await create_tween().tween_property(platform_player, "modulate:a", 1, .5).finished
	elif Input.is_action_just_pressed("platformer_player_interact") and doorway_activated == true and locked_door_activated == false:
		locked_door.play("open")
		await locked_door.animation_finished
		locked_door_opened = true
		await create_tween().tween_property(platform_player, "modulate:a", 0, .5).finished
		platform_player.position = Vector2(2303.0, -301.0)
		await create_tween().tween_property(platform_player, "modulate:a", 1, .5).finished

	if Input.is_action_just_pressed("platformer_player_drop"):
		two_way_platform.collision_enabled = false
	elif Input.is_action_just_released("platformer_player_drop"):
		two_way_platform.collision_enabled = true
	
	if is_dead == true:
		get_tree().reload_current_scene()

func foreground_on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		create_tween().tween_property(foreground_layer, "modulate:a", .2, .5)


func foreground_on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		create_tween().tween_property(foreground_layer, "modulate:a", 1, .5)


func key1_on_area_2d_body_entered(body: Node2D) -> void:
	picked_up1 = true
	pick_up1.visible = false

func side_door1_on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		side_door_locked1_activated = true

func side_door_locked1_on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		side_door_locked1_activated = false

func key2_on_area_2d_body_entered(body: Node2D) -> void:
	picked_up2 = true
	pick_up2.visible = false

func locked_door_on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		locked_door_activated = true

func locked_door_on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		locked_door_activated = false

func open_doorway_on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		doorway_activated = true

func open_doorway_on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		doorway_activated = false

func key3_on_area_2d_body_entered(body: Node2D) -> void:
	picked_up3 = true
	pick_up3.visible = false

func side_door_locked2_on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		side_door_locked2_activated = true

func side_door_locked2_on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		side_door_locked2_activated = false


func pickup4_on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	picked_up1 = true
	picked_up2 = true
	picked_up3 = true
	pick_upSkeleton.visible = false

func _on_deathtrap_body_entered(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		is_dead = true
