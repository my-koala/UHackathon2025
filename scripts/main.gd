@tool
extends Node

@export
var microgame_scenes: Array[MicroGame] = []
var _microgame_index: int = 0

@export
var lives: int = 5
var _lives: int = 5

@export
var run_microgames: bool = false
var _microgame_count: int = 0

@export
var minigame_time_scale_curve: Curve = Curve.new()


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	_lives = lives
	
	microgame_scenes

func loop_start() -> void:
	_lives = lives
	_microgame_index = 0
	microgame_scenes.shuffle()
	
	

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	
