extends Node2D

@export var direction : Vector2 = Vector2(1.0, 0.0)
@export var speed     : float = 40.0

var spawn_manager : Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _ready() -> void:
	spawn_manager = get_tree().get_first_node_in_group("SpawnManager")
	
func _process(delta: float) -> void:
	if position.x >= 1200.0:
		queue_free()
	elif position.x <= -1200.0:
		queue_free()
	
func _physics_process(delta: float) -> void:
	position += direction * speed * delta

func play_anim() -> void:
	animated_sprite_2d.play("animate")
