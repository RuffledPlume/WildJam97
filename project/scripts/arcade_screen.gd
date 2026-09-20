@tool
class_name ArcadeScreen extends Node3D

@export var viewport_target : SubViewport

@export var screen_shader : Shader
@export var screen_mesh : MeshInstance3D
@export var screen_light_array : Array[SpotLight3D]
@export var notifier : VisibleOnScreenNotifier3D
@export var on_screen_delay := 0.1
@export var off_screen_delay := 1.0

var screen_texture : ViewportTexture
var screen_material : ShaderMaterial
var drawable_texture := DrawableTexture2D.new()
var next_update := off_screen_delay

func _ready() -> void:
	if viewport_target == null:
		process_mode = Node.PROCESS_MODE_DISABLED
		return
	process_mode = Node.PROCESS_MODE_INHERIT
		
	screen_texture = viewport_target.get_texture()
	
	screen_material = ShaderMaterial.new()
	screen_material.shader = screen_shader
	screen_material.set_shader_parameter("screen_texture", screen_texture)
	
	screen_mesh.set_surface_override_material(0, screen_material)

func _process(_delta: float) -> void:
	if next_update > 0:
		next_update -= _delta
		return
	next_update = on_screen_delay if notifier.is_on_screen() else off_screen_delay

	var array_size := sqrt(screen_light_array.size()) as int
	var screen_image := screen_texture.get_image()

	screen_image.resize(array_size, array_size, Image.INTERPOLATE_TRILINEAR)

	for i in screen_light_array.size():
		var offset_x := i % array_size
		var offset_y := floor(i / (array_size as float)) as int
		screen_light_array[i].light_color = screen_image.get_pixel(offset_x, offset_y)
