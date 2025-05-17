class_name PasswordMicroGame
extends MicroGame

@export
var text_material : ShaderMaterial

@onready
var password_label : Label = $label2

@onready
var password_entry : LineEdit = $text_edit

var _char_list : String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ23456789"

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	if OS.get_name() == "Web":
		# disable shader dirty hack
		pass
		text_material.free()
		text_material = null

func start(time_scale: float, difficulty_scaling: float) -> void:
	password_label.text = ""
	password_entry.text = ""
	
	super(time_scale, difficulty_scaling)
	
	password_label.text = _generate_word(_char_list, lerpf(5, 8, difficulty_scaling))
	password_entry.grab_focus()
	
	# apply difficulty scaling to shader
	if is_instance_valid(text_material):
		text_material.set_shader_parameter("DifficultyScale", lerpf(0.35, 1.25, difficulty_scaling))
	

func _generate_word(chars : String, length : int) -> String:
	var word : String
	for i : int in range(length):
		word += chars[randi() % len(chars)]
	return word

func _text_changed(new_text: String) -> void:
	if (password_entry.text == password_label.text):
		complete(true)
