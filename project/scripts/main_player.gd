class_name MainPlayer extends CharacterBody3D

static var INSTANCE : MainPlayer

# TODO: Mouse Sense should live in a Game Settings so we can have it easily configureable
@export var mouse_sense := 2.0
@export var base_speed := 5.0
@export var run_mod := 2.0
@export var interaction_distance := 5.0

@export var camera: Camera3D

var mouse_delta : Vector2
var move_delta : Vector2
var current_pitch : float

var hovering_interactable : Interactable
var hovering_interactable_position : Vector3

var is_locked := false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	INSTANCE = self

func _process(delta: float) -> void:
	if is_locked:
		return
		
	_handle_camera_rotation(delta)
	_handle_interactions()

func _physics_process(delta: float) -> void:
	if is_locked:
		return
		
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

func _handle_interactions() -> void:
	var ray_start := camera.global_position
	var ray_end := ray_start + (camera.global_basis * Vector3.FORWARD) * interaction_distance
	var result := get_world_3d().direct_space_state.intersect_ray(
		PhysicsRayQueryParameters3D.create(ray_start, ray_end))
	
	var new_hovering_interactable : Interactable = null
	if result:
		var collider = result["collider"]
		if collider is Interactable:
			var collider_interactable := collider as Interactable
			if collider_interactable.can_interact_with():
				new_hovering_interactable = collider_interactable
				hovering_interactable_position = result["position"]
	
	if hovering_interactable != new_hovering_interactable:
		if hovering_interactable != null && Input.is_action_pressed("main_player_interact"):
			hovering_interactable.on_interact_with_released()
	
	hovering_interactable = new_hovering_interactable
	
	if hovering_interactable != null:
		if Input.is_action_just_pressed("main_player_interact"):
			hovering_interactable.on_interact_with_pressed()
		elif Input.is_action_pressed("main_player_interact"):
			hovering_interactable.on_interact_with_held()
		elif Input.is_action_just_released("main_player_interact"):
			hovering_interactable.on_interact_with_released()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			mouse_delta = -event.relative * mouse_sense
	
	if event is InputEventMouseButton:
		if event.pressed:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
