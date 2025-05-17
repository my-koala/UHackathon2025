class_name SelectImageMicroGame
extends MicroGame

const IMAGE_BUTTON: PackedScene = preload("res://assets/microgame/select_image/image_button.tscn")

@export
var image_library: Array[Texture2D] = []

@onready
var _preview_text: RichTextLabel = $label

@onready
var _container: GridContainer = $grid_container

var _buttons: Array[TextureButton] = []
var _expected_image: Texture2D = null
var _expected_buttons: int = 9
var _correct_buttons: int = 0

func start(time_scale: float, difficulty_scaling: float) -> void:
	# Clean up from previous iteration
	_correct_buttons = 0
	_expected_buttons = 0
	
	for old_button: TextureButton in _buttons:
		old_button.queue_free()
	_buttons.clear()
	
	# Calculate new length
	var side_length : int = lerp(3, 5, difficulty_scaling)
	_container.columns = side_length
	
	# Our expected image is a random one of these 4
	_expected_image = image_library[randi() % image_library.size()]
	
	# Populate our texture buttons with random images from our subset
	for i: int in range(side_length * side_length):
		var button: TextureButton = IMAGE_BUTTON.instantiate()
		button.pressed.connect(func() -> void: _on_texture_toggle(i))
		_container.add_child(button)
		
		var image: Texture2D = image_library[randi() %  image_library.size()]
		button.texture_normal = image
		
		# Increment expected count if texture is expected
		if image == _expected_image:
			_expected_buttons = _expected_buttons + 1
		
		_buttons.append(button)
	
	# If we have no expected images, force a random button to have our expected image
	if _expected_buttons == 0:
		_buttons[randi() % _buttons.size()].texture_normal = _expected_image
		_expected_buttons = 1
	
	_preview_text.clear()
	_preview_text.add_text("Select all: ")
	_preview_text.add_image(_expected_image, 32, 32)
	
	# Start
	super(time_scale, difficulty_scaling)

func _on_texture_toggle(button_idx: int) -> void:
	if !_running:
		return
	
	var button: TextureButton = _buttons[button_idx]
	
	if button.pressed:
		_on_texture_pressed(button_idx)
	else:
		_on_texture_unpressed(button_idx)

func _on_texture_pressed(button_idx: int) -> void:
	var button_texture : Texture2D = _buttons[button_idx].texture_normal
	
	if button_texture == _expected_image:
		_correct_buttons = min(_buttons.size(), _correct_buttons + 1)
	else:
		complete(false)
	
	_process_images()

func _on_texture_unpressed(button_idx: int) -> void:
	var button_texture : Texture2D = _buttons[button_idx].texture_normal
	
	if button_texture == _expected_image:
		_correct_buttons = max(_correct_buttons - 1, 0)
	
	_process_images()

func _process_images() -> void:
	if _correct_buttons >= _expected_buttons:
		complete(true)
