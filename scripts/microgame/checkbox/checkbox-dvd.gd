class_name CheckBoxDvd
extends CheckBox

@export
var defaultPosition: Vector2

@export
var maxBounds: Vector2

@export
var speed: float

var direction: Vector2
var current_difficulty_scale: float

# func _ready() -> void:
#	initialize(0.5)
		
func initialize(difficulty_scale: float) -> void:
	direction = Vector2(random_direction(), random_direction())
	position = defaultPosition
	current_difficulty_scale = difficulty_scale
	
	# clamp lower values to avoid slight movement
	if (current_difficulty_scale < 0.1):
		current_difficulty_scale = 0

func _process(delta: float) -> void:
	position += direction * (speed * current_difficulty_scale * delta)
	
	# quick DVD logo logic
	var normalizedPosition: Vector2 = position - defaultPosition
	if (normalizedPosition.y > maxBounds.y):
		position.y = defaultPosition.y + maxBounds.y
		advance_direction(true)
	if (normalizedPosition.y < -maxBounds.y):
		position.y = defaultPosition.y - maxBounds.y
		advance_direction(true)
	if (normalizedPosition.x > maxBounds.x):
		position.x = defaultPosition.x + maxBounds.x
		advance_direction(false)
	if (normalizedPosition.x < -maxBounds.x):
		position.x = defaultPosition.x - maxBounds.x
		advance_direction(false)

func advance_direction(hit_was_vertical: bool) -> void:
	if (hit_was_vertical):
		direction.y = -direction.y
	else:
		direction.x = -direction.x
	
func random_direction() -> float:
	if (randi() % 2 == 0):
		return 0.5
	else:
		return -0.5
