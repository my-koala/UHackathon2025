@tool
extends Node

@export
var run_microgames: bool = false
var _microgame_count: int = 0

@export
var minigame_time_scale_curve: Curve = Curve.new()


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	
