@tool
class_name ArcadeScreen extends Node

@export var viewport_target : SubViewport

@export var screen_shader : Shader
@export var screen_mesh : MeshInstance3D
@export var screen_light : AreaLight3D
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
				
	var screen_width := screen_texture.get_width()
	var screen_height := screen_texture.get_height()
	if screen_width <= 0 || screen_height <= 0:
		return
		
	screen_light.area_texture = null
	if drawable_texture.get_width() != screen_width || drawable_texture.get_height() != screen_height:
		drawable_texture.setup(screen_width, screen_height, DrawableTexture2D.DRAWABLE_FORMAT_RGBA8, Color.WHITE, true)
		
	drawable_texture.blit_rect(Rect2i(0, 0, screen_width, screen_height), screen_texture)
	screen_light.area_texture = drawable_texture
	
	next_update = on_screen_delay if notifier.is_on_screen() else off_screen_delay
