extends CharacterBody2D

signal interacted

@export var speed         : float = 3.0
@export var max_speed     : float = 150.0
@export var jump_velocity : float = -400.0

var health    : int = 3
var is_flying : bool = false
var gravity   : float = 980.0
var canvas_layer : CanvasLayer

@onready var damage_timer: Timer = %DamageTimer

func _ready() -> void:
	canvas_layer = get_tree().get_first_node_in_group("CanvasLayer")
	canvas_layer.start_flying.connect(set_to_flying)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("interact"):
		interacted.emit()

func _physics_process(delta: float) -> void:
	
	if not is_on_floor() and not is_flying:
		velocity.y += gravity * delta
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	# HANDLE GROUND INPUTS AND SPEEDS
	if not is_flying:
		if Input.is_action_pressed("main_player_move_left"):
			velocity += Vector2(-10.0, 0.0)
		elif Input.is_action_pressed("main_player_move_right"):
			velocity += Vector2(10.0, 0.0)
		
		velocity = velocity.move_toward(Vector2.ZERO, 5.0)
		velocity = velocity.limit_length(max_speed)
	
	# HANDLE FLYING INPUTS AND SPEEDS
	if is_flying:
		if Input.is_action_pressed("main_player_move_left"):
			velocity += Vector2(-speed, 0.0)
		if Input.is_action_pressed("main_player_move_right"):
			velocity += Vector2(speed, 0.0)
		if Input.is_action_pressed("main_player_move_forward"):
			velocity += Vector2(0.0, -speed * 0.6)
		if Input.is_action_pressed("main_player_move_back"):
			velocity += Vector2(0.0, speed * 0.6)
		
		velocity = velocity.move_toward(Vector2.ZERO, 0.5)
		velocity = velocity.limit_length(max_speed)

	move_and_slide()
	
	if damage_timer.time_left <= 0.0:
		for i in get_slide_collision_count():
			var collider := get_slide_collision(i).get_collider()
			if collider.is_in_group("Hazard"):
				take_damage()
				damage_timer.start(2.0)
				break
				
	
func take_damage() -> void:
	health -= 1
	if health <= 0:
		print("GAMEOVER")
		print(health)

func set_to_flying() -> void:
	is_flying = true
