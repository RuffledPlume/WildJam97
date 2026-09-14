extends Area2D


@export var direction : Vector2 = Vector2(0.0, 0.0)

var player        : CharacterBody2D
var is_within     : bool = false
var canvas_layer  : CanvasLayer
var spawn_manager : Node2D

@onready var fire : Sprite2D = %Fire
@onready var e_label: Label = %Label

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	player.interacted.connect(interact)
	canvas_layer = get_tree().get_first_node_in_group("CanvasLayer")
	spawn_manager = get_tree().get_first_node_in_group("SpawnManager")
	
func _physics_process(delta: float) -> void:
	position += direction * spawn_manager.speed * delta
	# Change to animation or tween movement.
	
func interact() -> void:
	if is_within:
		fire.visible = true
		e_label.visible = false
		canvas_layer.initialise_flying()
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		is_within = true
