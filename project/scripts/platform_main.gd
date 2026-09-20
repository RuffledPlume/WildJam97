class_name Platformer extends Node2D

@export var arcade : ArcadeMachine

var sign1_activated = false
var sign2_activated = false
var sign3_activated = false
var sign4_activated = false
var sign5_activated = false
var sign6_activated = false
var picked_up1 = false
var picked_up2 = false
var picked_up3 = false
var side_door_locked1_activated = false
var side_door_locked2_activated = false
var locked_door_activated = false
var doorway_activated = false
var locked_door_opened = false
var is_dead = false
var textbox_up = false
var timer_activated = false
var end_screen_activated = false
var win_screen_activated = false
var secret1_got = false
var secret2_got = false
var secret3_got = false
var won_game = false
var endscreen_timer_activated = false
var statue_activated = false
var statue_moved = false
var start_pause_up = false

@onready var pick_up1 = %pick_up1
@onready var pick_up2 = %pick_up2
@onready var pick_up3 = %pick_up3
@onready var pick_upSkeleton = %pick_up4
@onready var locked_door = %locked_door
@onready var side_door_locked1 = %side_door_locked1
@onready var side_door_locked2 = %side_door_locked2
@onready var side_door1_coll = %side_door1_coll
@onready var side_door2_coll = %side_door2_coll
@onready var text = %text
@onready var platform_player = %player
@onready var two_way_platform = %two_way_platform
@onready var foreground_layer = %foreground
@onready var textbox_animation = %AnimationPlayer
@onready var timer = %Timer
@onready var time_stat_label_death = %death_time_stat
@onready var secret_stat_label_death = %death_secret_stat
@onready var time_stat_label_won = %won_time_stat
@onready var secret_stat_label_won = %won_secret_stat
@onready var endscreen_timer = %end_screen_timer
@onready var player_sprite = %player_sprite
@onready var press_anything_text = %press_anything
@onready var key_pickup_sfx = %key_pickup
@onready var secret_get_sfx = %secret_get
@onready var door_open_sfx = %door_open
@onready var background_music = %background_music
@onready var textbox_popup_sfx = %textbox_popup
@onready var title_music = %title_music

var secrets_got = 0
var seconds_passed = 0
var minutes_passed = 0
var hours_passed = 0

func textbox(param: String):
	textbox_popup_sfx.play()
	platform_player.can_move = false
	text.text = ""
	text.append_text(param)
	textbox_animation.play("textbox_fadein")
	textbox_up = true

func add_text_to_textbox(sign_number, text_param: String):
	if arcade.is_action_just_released("platformer_player_interact") and sign_number == true and textbox_up == false:
		textbox(text_param)

func add_text_to_secret(sign_number, text_param: String, secret_param: int):
	if arcade.is_action_just_released("platformer_player_interact") and sign_number == true and textbox_up == false:
		secret_get_sfx.play()
		textbox(text_param)
		if secret_param == 2:
			secret2_got = true
		elif secret_param == 3:
			secret3_got = true
		else:
			pass

func add_text_to_locked(door_activated, text_param: String, pickup_param):
	if arcade.is_action_just_released("platformer_player_interact") and door_activated == true and textbox_up == false and pickup_param == false:
		textbox(text_param)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	background_music.play()
	textbox_animation.play("fade_transition_in")
	await textbox_animation.animation_finished
	platform_player.can_move = false
	textbox_animation.play("textblink")
	start_pause_up = true
	if arcade == null:
		arcade = get_parent().get_parent() as ArcadeMachine # It is what it is
	platform_player.arcade = arcade

func _physics_process(_delta: float) -> void:
	if arcade == null:
		return
		
	if arcade.is_player_using && start_pause_up == true:
		textbox_animation.stop()
		press_anything_text.visible = false
		platform_player.can_move = true
		start_pause_up = false
		textbox_animation.play("text_fade_in")
		return
	
	if arcade.is_action_just_pressed("platformer_player_interact") and picked_up1 == true and side_door_locked1_activated == true:
		door_open_sfx.play()
		side_door_locked1.play("open")
		side_door1_coll.disabled = true
	elif arcade.is_action_just_pressed("platformer_player_interact") and picked_up1 != true and side_door_locked1_activated == true:
		add_text_to_textbox(side_door_locked1_activated, "This door is locked! I wonder if there's a key nearby.")
	
	add_text_to_textbox(sign1_activated, "Press W to jump, press it twice to double jump!")
	add_text_to_textbox(sign2_activated, "Some walls look different, and disappear when you collide into them")
	add_text_to_textbox(sign3_activated, "If you want to drop from a thin platform, press D!")
	add_text_to_textbox(sign4_activated, "There's a hidden key that unlocks all doors no matter the color.")
	add_text_to_secret(sign5_activated, "Don't fall!", 2)
	add_text_to_secret(sign6_activated, "You found me! Congrats!", 3)
	add_text_to_locked(side_door_locked1_activated, "This door is locked! I wonder if a key is around here somewhere...", picked_up1)
	add_text_to_locked(locked_door_activated, "Another locked door...", picked_up2)
	add_text_to_locked(side_door_locked2_activated, "Even the front door is locked?! I guess that makes sense...", picked_up3)
	
	if arcade.is_anything_pressed() and textbox_up == true:
		textbox_animation.play("textbox_fadeout")
		await textbox_animation.animation_finished
		platform_player.can_move = true
		textbox_up = false
	
	if arcade.is_action_just_pressed("platformer_player_interact") and picked_up3 == true and side_door_locked2_activated == true:
		door_open_sfx.play()
		side_door_locked2.play("open")
		side_door2_coll.disabled = true
	elif arcade.is_action_just_pressed("platformer_player_interact") and picked_up3 != true and side_door_locked2_activated == true:
		add_text_to_textbox(side_door_locked2_activated, "Even the front door is locked?! I guess that makes sense...")

	if arcade.is_action_just_pressed("platformer_player_interact") and picked_up2 == true and locked_door_activated == true and locked_door_opened == false:
		door_open_sfx.play()
		locked_door.play("open")
		await locked_door.animation_finished
		locked_door_opened = true
	elif arcade.is_action_just_pressed("platformer_player_interact") and picked_up2 != true and locked_door_activated == true and locked_door_opened == false:
		add_text_to_textbox(locked_door_activated, "Another locked door...")
	
	if arcade.is_action_just_pressed("platformer_player_interact") and locked_door_activated == true and locked_door_opened == true:
		platform_player.can_move = false
		await create_tween().tween_property(platform_player, "modulate:a", 0, .5).finished
		platform_player.position = Vector2(2303.0, -688.0)
		await create_tween().tween_property(platform_player, "modulate:a", 1, .5).finished
		platform_player.can_move = true

	if arcade.is_action_just_pressed("platformer_player_interact") and doorway_activated == true and locked_door_opened == true:
		platform_player.can_move = false
		await create_tween().tween_property(platform_player, "modulate:a", 0, .5).finished
		platform_player.position = Vector2(2303.0, -301.0) 
		await create_tween().tween_property(platform_player, "modulate:a", 1, .5).finished
		platform_player.can_move = true
	elif arcade.is_action_just_pressed("platformer_player_interact") and doorway_activated == true and locked_door_opened == false:
		platform_player.can_move = false
		door_open_sfx.play()
		locked_door.play("open")
		await locked_door.animation_finished
		locked_door_opened = true
		await create_tween().tween_property(platform_player, "modulate:a", 0, .5).finished
		platform_player.position = Vector2(2303.0, -301.0)
		await create_tween().tween_property(platform_player, "modulate:a", 1, .5).finished
		platform_player.can_move = true

	if arcade.is_action_just_pressed("platformer_player_drop"):
		two_way_platform.collision_enabled = false
	elif arcade.is_action_just_released("platformer_player_drop"):
		two_way_platform.collision_enabled = true
	
	if is_dead == true and end_screen_activated == false:
		key_pickup_sfx.play()
		var hours = ""
		var minutes = ""
		var seconds = ""
		platform_player.can_move = false
		player_sprite.play("death")
		
		if hours_passed < 10:
			hours = "0" + str(hours_passed)
		else:
			hours = str(hours_passed)
		
		if minutes_passed < 10:
			minutes = "0" + str(minutes_passed)
		else:
			minutes = str(minutes_passed)
		
		if seconds_passed < 10:
			seconds = "0" + str(seconds_passed)
		else:
			seconds = str(seconds_passed)
		
		time_stat_label_death.text = hours + ":" + minutes + ":" + seconds
		secret_stat_label_death.text = str(secrets_got) + "/3"
		textbox_animation.play("death")
		end_screen_activated = true
		await textbox_animation.animation_finished
		endscreen_timer.start()
	
	if won_game == true and win_screen_activated == false:
		background_music.stop()
		secret_get_sfx.play()
		title_music.play()
		var hours = ""
		var minutes = ""
		var seconds = ""
		platform_player.can_move = false
		player_sprite.play("win")
		
		if hours_passed < 10:
			hours = "0" + str(hours_passed)
		else:
			hours = str(hours_passed)
		
		if minutes_passed < 10:
			minutes = "0" + str(minutes_passed)
		else:
			minutes = str(minutes_passed)
		
		if seconds_passed < 10:
			seconds = "0" + str(seconds_passed)
		else:
			seconds = str(seconds_passed)
		
		time_stat_label_won.text = hours + ":" + minutes + ":" + seconds
		secret_stat_label_won.text = str(secrets_got) + "/3"
		textbox_animation.play("won")
		win_screen_activated = true
		await textbox_animation.animation_finished
		endscreen_timer.start()
	
	if arcade.is_anything_pressed() and end_screen_activated == true and endscreen_timer_activated == true:
		textbox_animation.play("fade_transition_out")
		endscreen_timer_activated = false
		arcade.restart()
	if arcade.is_anything_pressed() and win_screen_activated == true and endscreen_timer_activated == true:
		textbox_animation.play("fade_transition_out")
		endscreen_timer_activated = false
		arcade.restart()
	
	if seconds_passed >= 60:
		seconds_passed = 0
		minutes_passed += 1
	
	if minutes_passed >= 60:
		minutes_passed = 0
		hours_passed += 1

func foreground_on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		create_tween().tween_property(foreground_layer, "modulate:a", .2, .5)


func foreground_on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		create_tween().tween_property(foreground_layer, "modulate:a", 1, .5)


func key1_on_area_2d_body_entered(_body: Node2D) -> void:
	if pick_up1.visible == true:
		key_pickup_sfx.play()
	picked_up1 = true
	pick_up1.visible = false

func side_door1_on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		side_door_locked1_activated = true

func side_door_locked1_on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		side_door_locked1_activated = false

func key2_on_area_2d_body_entered(_body: Node2D) -> void:
	if pick_up2.visible == true:
		key_pickup_sfx.play()
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

func key3_on_area_2d_body_entered(_body: Node2D) -> void:
	if pick_up3.visible == true:
		key_pickup_sfx.play()
	picked_up3 = true
	pick_up3.visible = false

func side_door_locked2_on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		side_door_locked2_activated = true

func side_door_locked2_on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		side_door_locked2_activated = false


func pickup4_on_area_2d_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	picked_up1 = true
	picked_up2 = true
	picked_up3 = true
	pick_upSkeleton.visible = false
	if secret3_got == false:
		secret_get_sfx.play()
		secrets_got += 1
		secret3_got = true

func _on_deathtrap_body_entered(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		is_dead = true


func _on_sign_1_body_entered(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		sign1_activated = true


func _on_sign_1_body_exited(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		sign1_activated = false


func _on_sign_2_body_entered(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		sign2_activated = true

func _on_sign_2_body_exited(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		sign2_activated = false


func _on_sign_3_body_entered(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		sign3_activated = true


func _on_sign_3_body_exited(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		sign3_activated = false


func _on_sign_4_body_entered(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		sign4_activated = true


func _on_sign_4_body_exited(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		sign4_activated = false


func _on_sign_5_body_entered(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		sign5_activated = true


func _on_sign_5_body_exited(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		sign5_activated = false
		if secret2_got == true:
			secrets_got += 1
		else:
			pass


func _on_sign_6_body_entered(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		sign6_activated = true


func _on_sign_6_body_exited(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		sign6_activated = false
		if secret3_got == true:
			secrets_got += 1
		else:
			pass

func _on_timer_timeout() -> void:
	seconds_passed += 1


func _on_win_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		won_game = true


func _on_end_screen_timer_timeout() -> void:
	endscreen_timer_activated = true


func statue_on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("platform_player"):
		statue_activated = true
