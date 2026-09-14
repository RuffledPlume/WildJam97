extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -800.0

@onready var sprite_animation = $player_sprite

var can_doublejump = false

func play(param):
	sprite_animation.play(param)

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		play("falling")

	# Handle jump.
	if Input.is_action_just_pressed("platformer_player_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		play("jump")
		can_doublejump = true
	elif Input.is_action_just_pressed("platformer_player_jump") and can_doublejump == true and !is_on_floor():
		velocity.y = JUMP_VELOCITY
		play("jump")
		can_doublejump = false

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("platformer_player_left", "platformer_player_right")
	if direction:
		velocity.x = direction * SPEED
		play("walking")
		if Input.is_action_pressed("platformer_player_left"):
			sprite_animation.flip_h = true
		else:
			sprite_animation.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		play("idle")

	move_and_slide()
