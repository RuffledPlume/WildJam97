@tool
extends AreaLight3D

@export var screen_texture : ViewportTexture
@export var update_delay := 0.1

var drawable_texture : DrawableTexture2D
var current_delay := update_delay

func _ready() -> void:
	drawable_texture = area_texture as DrawableTexture2D

func _process(_delta: float) -> void:
	if current_delay > 0:
		current_delay -= _delta
		return
		
	if drawable_texture == null || screen_texture == null:
		return
		
	var screen_width := screen_texture.get_width()
	var screen_height := screen_texture.get_height()
	if screen_width <= 0 || screen_height <= 0:
		return
		
	area_texture = null
	if drawable_texture.get_width() != screen_width || drawable_texture.get_height() != screen_height:
		drawable_texture.setup(screen_width, screen_height, DrawableTexture2D.DRAWABLE_FORMAT_RGBA8, Color.WHITE, true)
		
	drawable_texture.blit_rect(Rect2i(0, 0, screen_width, screen_height), screen_texture)
	area_texture = drawable_texture
	current_delay = update_delay
