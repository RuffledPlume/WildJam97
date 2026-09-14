class_name FloatUpSpawnable
extends Node2D

@export var direction : Vector2 = Vector2(0.0, 0.0)
@export var speed     : float = 1.0
var spawn_manager : Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	spawn_manager = get_tree().get_first_node_in_group("SpawnManager")
	
func _process(delta: float) -> void:
	if position.y >= 700.0:
		queue_free()
	
func _physics_process(delta: float) -> void:
	position += direction * (spawn_manager.speed * speed) * delta

func play_anim() -> void:
	animated_sprite_2d.play("animate")
