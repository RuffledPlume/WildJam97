extends CharacterBody3D

var jump_velocity : float = 2.0
var speed   : float = 1.0

var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		
	var input_dir := Input.get_axis("main_player_move_right", "main_player_move_left")
	velocity.x = input_dir * speed
	velocity.z = 0.0

	move_and_slide()
