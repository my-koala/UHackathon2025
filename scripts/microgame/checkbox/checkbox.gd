class_name CheckboxMicroGame
extends MicroGame

@onready
var checkbox: CheckBoxDvd = $check_box

func start(time_scale: float, difficulty_scale: float) -> void:
	checkbox.set_pressed_no_signal(false)
	checkbox.initialize(difficulty_scale)
	super(time_scale, difficulty_scale)
