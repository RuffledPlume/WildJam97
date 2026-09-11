class_name MainPlayer extends CharacterBody3D

# TODO: Mouse Sense should live in a Game Settings so we can have it easily configureable
@export var mouse_sense := 2.0
@export var base_speed := 5.0
@export var run_mod : = 2.0

@export var camera: Camera3D

var mouse_delta : Vector2
var move_delta : Vector2
var current_pitch : float

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # TODO: Implement proper mouse capture tracking, Maybe in the GameManager?

func _process(delta: float) -> void:
	_handle_camera_rotation(delta)

func _physics_process(delta: float) -> void:
	if is_on_floor():
		var input_dir = Input.get_vector("main_player_move_left", "main_player_move_right", "main_player_move_forward", "main_player_move_back")
		input_dir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		
		velocity.x = input_dir.x * base_speed
		velocity.z = input_dir.z * base_speed 
	
	velocity += get_gravity() * delta
	move_and_slide()

func _handle_camera_rotation(delta: float) -> void:
	mouse_delta *= delta
	rotate_y(mouse_delta.x)
	camera.rotate_x(mouse_delta.y)
	camera.rotation_degrees.x = clampf(camera.rotation_degrees.x, -90.0, 90.0)
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			mouse_delta = -event.relative * mouse_sense
			
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
