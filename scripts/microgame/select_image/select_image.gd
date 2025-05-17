class_name SelectImageMicroGame
extends MicroGame

@export
var image_library: Array[Texture2D] = []

@export
var buttons: Array[TextureButton] = []

@onready
var _preview_text: RichTextLabel = $label

var _expected_image: Texture2D = null

var _expected_buttons: int = 9
var _correct_buttons: int = 0

# I dont want to hook these signals up manually LMAO
func _ready() -> void:
	for i: int in range(buttons.size()):	
		var button: TextureButton = buttons[i]
		button.pressed.connect(func() -> void: _on_texture_toggle(i))
	super()

func start(time_scale: float) -> void:
	_correct_buttons = 0
	_expected_buttons = 0
	
	# Our expected image is a random one of these 4
	_expected_image = image_library[randi() % image_library.size()]
	
	# Populate our texture buttons with random images from our subset
	for button: TextureButton in buttons:
		var image: Texture2D = image_library[randi() %  image_library.size()]
		button.texture_normal = image
		
		# Increment expected count if texture is expected
		if image == _expected_image:
			_expected_buttons = _expected_buttons + 1
	
	# If we have no expected images, force a random button to have our expected image
	if _expected_buttons == 0:
		buttons[randi() % buttons.size()].texture_normal = _expected_image
		_expected_buttons = 1
	
	_preview_text.text = "Select all: "
	_preview_text.add_image(_expected_image, 32, 32)
	
	# Start
	super(time_scale)

func _on_texture_toggle(button_idx: int) -> void:
	var button: TextureButton = buttons[button_idx]
	
	if button.pressed:
		_on_texture_pressed(button_idx)
	else:
		_on_texture_unpressed(button_idx)

func _on_texture_pressed(button_idx: int) -> void:
	var button_texture : Texture2D = buttons[button_idx].texture_normal
	
	if button_texture == _expected_image:
		_correct_buttons = min(buttons.size(), _correct_buttons + 1)
	else:
		complete(false)
	
	_process_images()

func _on_texture_unpressed(button_idx: int) -> void:
	var button_texture : Texture2D = buttons[button_idx].texture_normal
	
	if button_texture == _expected_image:
		_correct_buttons = max(_correct_buttons - 1, 0)
	
	_process_images()

func _process_images() -> void:
	if _correct_buttons >= _expected_buttons:
		complete(true)
