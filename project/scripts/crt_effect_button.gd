extends FocusableWidget

@export var state_label : Label

var state := true

func _process(delta: float) -> void:
	super._process(delta)
	if !_is_focused:
		return
	
	var dir := _arcade.get_axis("ui_left", "ui_right")
	if dir == 0.0:
		return
		
	var new_state : bool
	if dir < 0: new_state = false
	elif dir > 0: new_state = true
	
	if new_state == state:
		return
	state = new_state
		
	if state:
		print("Enabled CRT")
		state_label.text = "On"
		RenderingServer.global_shader_parameter_set("CRT_ENABLED", true)
	else:
		print("Disabled CRT")
		state_label.text = "Off"
		RenderingServer.global_shader_parameter_set("CRT_ENABLED", false)
