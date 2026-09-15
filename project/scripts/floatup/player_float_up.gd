extends CharacterBody2D

signal interacted
signal health_changed(int)
signal shrinked
signal steering
signal player_died

@export var speed         : float = 3.0
@export var drag          : float = 0.5
@export var max_speed     : float = 150.0
@export var jump_velocity : float = -400.0

var health            : int = 3
var is_flying         : bool = false
var allow_shrink      : bool = false
var allow_steer       : bool = false
var disable_player    : bool = false
var gravity           : float = 980.0
var canvas_layer      : CanvasLayer
var resize_factor     : float = 1.0
var resize_multiplier : float = 0.01

@onready var damage_timer: Timer = %DamageTimer
@onready var shrink_timer: Timer = %ShrinkTimer
@onready var steer_timer: Timer = %SteerTimer
@onready var anim_player_main: AnimationPlayer = %AnimPlayerMain
@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D

func _ready() -> void:
	canvas_layer = get_tree().get_first_node_in_group("CanvasLayer")
	canvas_layer.start_flying.connect(set_to_flying)
	shrink_timer.timeout.connect(remove_shrink)
	steer_timer.timeout.connect(remove_steer)
	player_died.connect(disable_input)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		interacted.emit()
	
	if Input.is_action_just_pressed("scroll_mouse_down"):
		resize_factor -= resize_multiplier
		self.scale = Vector2(resize_factor, resize_factor)

func _process(delta: float) -> void:
	if resize_factor < 1.0:
		resize_factor += 0.001
		self.scale = Vector2(resize_factor, resize_factor)
	resize_factor = clamp(resize_factor, 0.5, 1.0)
	
	if health <= 0:
		player_died.emit()
		

func disable_input() ->  void:
	disable_player = true
	anim_player_main.play("death")
	
func _physics_process(delta: float) -> void:
	
	if disable_player:
		return 
		
	if not is_on_floor() and not is_flying:
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	# HANDLE GROUND INPUTS AND SPEEDS
	if not is_flying:
		animated_sprite_2d.play("idle")
		if Input.is_action_pressed("main_player_move_left"):
			animated_sprite_2d.play("walk")
			animated_sprite_2d.flip_h = true
			velocity += Vector2(-10.0, 0.0)
		elif Input.is_action_pressed("main_player_move_right"):
			animated_sprite_2d.play("walk")
			animated_sprite_2d.flip_h = false
			velocity += Vector2(10.0, 0.0)
		else:
			animated_sprite_2d.play("idle")
		
		velocity = velocity.move_toward(Vector2.ZERO, 5.0)
		velocity = velocity.limit_length(max_speed)
	
	# HANDLE FLYING INPUTS AND SPEEDS
	if is_flying:
		if Input.is_action_pressed("main_player_move_left"):
			animated_sprite_2d.play("flying")
			animated_sprite_2d.flip_h = true
			velocity += Vector2(-speed, 0.0)
		if Input.is_action_pressed("main_player_move_right"):
			animated_sprite_2d.play("flying")
			animated_sprite_2d.flip_h = false
			velocity += Vector2(speed, 0.0)
		if Input.is_action_pressed("main_player_move_forward"):
			velocity += Vector2(0.0, -speed * 0.7)
		if Input.is_action_pressed("main_player_move_back"):
			velocity += Vector2(0.0, speed * 0.7)
		
		velocity = velocity.move_toward(Vector2.ZERO, drag)
		velocity = velocity.limit_length(max_speed)

	move_and_slide()
	
	if damage_timer.time_left <= 0.0:
		for i in get_slide_collision_count():
			var collider := get_slide_collision(i).get_collider()
			
			if collider.is_in_group("Hazard"):
				take_damage()
				collider.play_anim()
				damage_timer.start(2.0)
				break
				
func take_damage() -> void:
	var damage : int = 1
	health -= damage
	health = clamp(health, 0, 3)
	if health <= 0:
		print("Game Over")
		# add death state
	health_changed.emit()
	print(health)

func set_to_flying() -> void:
	is_flying = true

func remove_shrink() -> void:
	allow_shrink = false

func remove_steer() -> void:
	allow_steer = false
	drag = 0.5
	speed = 3.0

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("Shrink"):
		var all_objects = get_tree().get_nodes_in_group("Hazard")
		for obj in all_objects:
			obj.scale = Vector2(0.75, 0.75)
		shrink_timer.start()
		shrinked.emit()
		area.get_parent().queue_free()
		
	if area.is_in_group("Steer"):
		allow_steer = true
		drag = 3.0
		speed = 10.0
		steer_timer.start()
		steering.emit()
		area.get_parent().queue_free()
		
