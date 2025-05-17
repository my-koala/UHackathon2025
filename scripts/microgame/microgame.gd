class_name MicroGame
extends Control

signal on_complete(success: bool)

@export
var time_duration: float = 7.5

var _time_scale: float = 1
var _time_left: float = 7.5
var _running: bool = false

func get_time_left() -> float:
	return _time_left / time_duration

## Starts the microgame
func start(time_scale: float, difficulty_scale: float) -> void:
	_time_scale = time_scale
	_time_left = time_duration
	_running = true

func complete(success: bool) -> void:
	if !_running:
		return
	
	on_complete.emit(success)
	_running = false
	
	print("Microgame completed. Successful: " + str(success))

func _physics_process(delta: float) -> void:
	if !_running:
		return
	
	_time_left -= _time_scale * delta
	
	if (_time_left <= 0):
		complete(false)
