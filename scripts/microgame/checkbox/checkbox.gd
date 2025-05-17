class_name CheckboxMicroGame
extends MicroGame

@onready
var checkbox: CheckBox = $check_box

func start(time_scale: float) -> void:
	checkbox.set_pressed_no_signal(false)
	super(time_scale)
