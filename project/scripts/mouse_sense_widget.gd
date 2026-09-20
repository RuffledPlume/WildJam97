extends FocusableWidget

@export var SenseLabel : Label

func _process(delta: float) -> void:
	super._process(delta)
	if !_is_focused:
		return
		
	var sense := MainPlayer.INSTANCE.mouse_sense
	var new_sense := sense + _arcade.get_axis("ui_left", "ui_right") * delta
	if sense == new_sense:
		return
		
	SenseLabel.text = String.num(new_sense, 1)
	MainPlayer.INSTANCE.mouse_sense = new_sense
	
