@tool
extends Node

# TODO: static noise animation

@export
var micro_games: Array[MicroGame] = []
var _micro_game_current: MicroGame = null

@export
var lives: int = 5
var _lives: int = 5

@export
var run_micro_games: bool = false
var _micro_game_iteration: int = 0

@export
var micro_game_time_scale_curve: Curve = Curve.new()

@onready
var _animation_player: AnimationPlayer = $animation_player as AnimationPlayer


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	# play animations?
	# await for prompts?
	loop_start()
	

func loop_start() -> void:
	_lives = lives
	_micro_game_iteration = 0
	micro_games.shuffle()
	
	_micro_game_current = micro_games[micro_games.size() % _micro_game_iteration]
	_micro_game_current.on_complete.connect(_on_current_microgame_completed)
	# TODO: await for animation?
	
	_animation_player.play(&"microgame_enter")
	await _animation_player.animation_finished
	
	_micro_game_current.start(micro_game_time_scale_curve.sample(float(_micro_game_iteration)))

func _on_current_microgame_completed(success: bool) -> void:
	if !success:
		print("not successful, decrement lives")
		_lives -= 1
		# TODO: play life lost animation
	else:
		print("successful")
		# play some sort of success animation
	
	_animation_player.play(&"microgame_exit")
	await _animation_player.animation_finished
	
	_micro_game_iteration += 1
	loop_update()

func loop_update() -> void:
	if _lives <= 0:
		print("game over")
		
		# end the game, probably some animation
	
	

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	
