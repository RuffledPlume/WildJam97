extends Node2D

signal initialise_end_game

@export var speed        : float = 0.0
@export var spawnables   : Array[PackedScene]
@export var flyables     : Array[PackedScene]
@export var powerups     : Array[PackedScene]

var upper_spawn_points : Array[Node2D]
var side_spawn_points  : Array[Node2D]
var player        : CharacterBody2D
var canvas_layer  : CanvasLayer
var elapsed_time  : float = 80.0
var min_timer     : float = 5.0
var max_timer     : float = 10.0
var end_game      : bool = false
var stop_spawning : bool = false

@onready var spawn_point: Node2D = %SpawnPoint
@onready var upper_timer: Timer = %UpperTimer
@onready var side_timer: Timer = %SideTimer
@onready var power_timer: Timer = %PowerTimer
@onready var key: Node2D = %Key

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	canvas_layer = get_tree().get_first_node_in_group("CanvasLayer")
	canvas_layer.start_flying.connect(adjust_start_speed)
	canvas_layer.start_flying.connect(spawn_flying_objects)
	canvas_layer.start_flying.connect(spawn_upper_objects)
	upper_timer.timeout.connect(spawn_upper_objects)
	side_timer.timeout.connect(spawn_flying_objects)
	power_timer.timeout.connect(spawn_powerups)

	# Find spawn points and add them into their correct arrays
	for usp in get_tree().get_nodes_in_group("SpawnPoint"):
		upper_spawn_points.append(usp)
	for lsp in get_tree().get_nodes_in_group("LSpawnPoint"):
		side_spawn_points.append(lsp)
	for rsp in get_tree().get_nodes_in_group("RSpawnPoint"):
		side_spawn_points.append(rsp)
	
func _process(delta: float) -> void:
	if player.is_flying:
		speed += 0.5 * delta
		elapsed_time += delta
	
	if elapsed_time > 10.0:
		min_timer = 3.0
		max_timer = 5.0
	if elapsed_time > 25.0:
		min_timer = 2.5
		max_timer = 4.5
	if elapsed_time > 40.0:
		min_timer = 1.5
		max_timer = 3.5
	if elapsed_time > 50.0:
		min_timer = 0.5
		max_timer = 1.5
	if elapsed_time > 90.0:
		stop_spawning = true
	if elapsed_time > 95.0 and not end_game:
		initialise_end_game.emit()
		end_game = true

func spawn_upper_objects() -> void:
	if end_game:
		return
	var spawned_item : Node2D = spawnables.pick_random().instantiate()
	add_child(spawned_item)
	var random_u_spawn : Node2D = upper_spawn_points.pick_random()
	spawned_item.global_position = random_u_spawn.global_position
		
	upper_timer.start(randf_range(min_timer, max_timer))
	
func spawn_flying_objects() -> void:
	if end_game:
		return
		

	var spawned_item : Node2D = flyables.pick_random().instantiate()
	add_child(spawned_item)
	var random_s_spawn : Node2D = side_spawn_points.pick_random()
	spawned_item.global_position = random_s_spawn.global_position
	
	if random_s_spawn.is_in_group("LSpawnPoint"):
		spawned_item.direction = Vector2(1.0, randf_range(-0.5, 0.5))
		spawned_item.speed = randf_range(60.0, 140.0)
		spawned_item.get_child(1).flip_h = true
		
	elif random_s_spawn.is_in_group("RSpawnPoint"):
		spawned_item.direction = Vector2(-1.0, randf_range(-0.5, 0.5))
		spawned_item.speed = randf_range(60.0, 140.0)
	
	side_timer.start(randf_range(min_timer, max_timer))

func spawn_powerups() -> void:
	var spawned_powerup : Node2D = powerups.pick_random().instantiate()
	add_child(spawned_powerup)
	var random_u_spawn : Node2D = upper_spawn_points.pick_random()
	spawned_powerup.global_position = random_u_spawn.global_position
	power_timer.start(randf_range(5.0, 15.0))
	
# Function below is to set speed on falling objects
func adjust_start_speed() -> void:
	speed = 20.0
