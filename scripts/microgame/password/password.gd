class_name PasswordMicroGame
extends MicroGame

@onready
var password_label : Label = $label2

@onready
var password_entry : TextEdit = $text_edit

var _char_list : String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

func start(time_scale: float) -> void:
	password_label.text = ""
	password_entry.text = ""
	
	super(time_scale)
	
	password_label.text = _generate_word(_char_list, 6)
	password_entry.grab_focus()

func _generate_word(chars : String, length : int) -> String:
	var word : String
	for i : int in range(length):
		word += chars[randi() % len(chars)]
	return word

func _text_changed() -> void:
	if (password_entry.text == password_label.text):
		complete(true)
