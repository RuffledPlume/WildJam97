extends FocusableWidget

@export var brightnessLabel : Label

var brightness := 1.0

func _process(delta: float) -> void:
	super._process(delta)
	if !_is_focused:
		return
		
	var new_brigtness : float = clamp(brightness + _arcade.get_axis("ui_left", "ui_right") * delta, 1.0, 3.0)
	if brightness == new_brigtness:
		return
	brightness = new_brigtness
		
	brightnessLabel.text = String.num(brightness, 1)
	RenderingServer.global_shader_parameter_set("BRIGHTNESS", brightness)
	
