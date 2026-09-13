extends Node2D

@export var speed        : float = 0.0
@export var spawnables   : Array[PackedScene]
@export var flyables     : Array[PackedScene]

var upper_spawn_points : Array[Node2D]
var side_spawn_points  : Array[Node2D]
var canvas_layer : CanvasLayer
var elapsed_time : float = 0.0
var min_timer    : float = 5.0
var max_timer    : float = 10.0

@onready var spawn_point: Node2D = %SpawnPoint
@onready var upper_timer: Timer = %UpperTimer
@onready var side_timer: Timer = %SideTimer

func _ready() -> void:
	canvas_layer = get_tree().get_first_node_in_group("CanvasLayer")
	canvas_layer.start_flying.connect(adjust_start_speed)
	canvas_layer.start_flying.connect(spawn_flying_objects)
	canvas_layer.start_flying.connect(spawn_upper_objects)
	upper_timer.timeout.connect(spawn_upper_objects)
	side_timer.timeout.connect(spawn_flying_objects)

	# Find spawn points and add them into their correct arrays
	for usp in get_tree().get_nodes_in_group("SpawnPoint"):
		upper_spawn_points.append(usp)
	for lsp in get_tree().get_nodes_in_group("LSpawnPoint"):
		side_spawn_points.append(lsp)
	for rsp in get_tree().get_nodes_in_group("RSpawnPoint"):
		side_spawn_points.append(rsp)
	
func _process(delta: float) -> void:
	speed += 0.2 * delta
	elapsed_time += delta
	
	if elapsed_time > 20.0:
		min_timer = 4.0
		max_timer = 9.0
	if elapsed_time > 35.0:
		min_timer = 2.5
		max_timer = 8.0
	if elapsed_time > 50.0:
		min_timer = 1.5
		max_timer = 5.0
	if elapsed_time > 65.0:
		min_timer = 1.0
		max_timer = 3.0

func spawn_upper_objects() -> void:

	var spawned_item : Node2D = spawnables.pick_random().instantiate()
	add_child(spawned_item)
	var random_u_spawn : Node2D = upper_spawn_points.pick_random()
	spawned_item.global_position = random_u_spawn.global_position
		
	upper_timer.start(randf_range(min_timer, max_timer))
	

func spawn_flying_objects() -> void:
	for f in flyables:
		var spawned_item : Node2D = flyables.pick_random().instantiate()
		add_child(spawned_item)
		var random_s_spawn : Node2D = side_spawn_points.pick_random()
		spawned_item.global_position = random_s_spawn.global_position
		
		if random_s_spawn.is_in_group("LSpawnPoint"):
			spawned_item.direction = Vector2(1.0, randf_range(-0.5, 0.5))
			spawned_item.speed = randf_range(40.0, 100.0)
			
		elif random_s_spawn.is_in_group("RSpawnPoint"):
			spawned_item.direction = Vector2(-1.0, randf_range(-0.5, 0.5))
			spawned_item.speed = randf_range(40.0, 100.0)
	
	side_timer.start(randf_range(min_timer, max_timer))

func adjust_start_speed() -> void:
	speed = 20.0
