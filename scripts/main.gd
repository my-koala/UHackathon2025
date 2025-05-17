@tool
extends Node

# TODO: static noise animation
# TODO: gameover, lives check

@export
var micro_games: Array[MicroGame] = []
var _micro_game_current: MicroGame = null

@export
var lives: int = 5
var _lives: int = 5

var _micro_game_loop: bool = false
var _micro_game_iteration: int = 0

@export
var micro_game_time_scale_curve: Curve = Curve.new()

@onready
var _animation_player: AnimationPlayer = $animation_player as AnimationPlayer
@onready
var _gameover_button_restart: Button = $gameover/button_restart as Button
@onready
var _gameover_label_score: Label = $gameover/label_score as Label
@onready
var _gameover_animation_player: AnimationPlayer = $gameover/animation_player as AnimationPlayer

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	_gameover_button_restart.pressed.connect(_on_gameover_button_restart_pressed)
	
	# play animations?
	# await for prompts?
	loop_start()
	

func _on_gameover_button_restart_pressed() -> void:
	_gameover_animation_player.play(&"gameover_exit")
	loop_start()

func loop_start() -> void:
	if _micro_game_loop:
		return
	_micro_game_loop = true
	_lives = lives
	_micro_game_iteration = 0
	micro_games.shuffle()
	_set_next_microgame()

func loop_stop() -> void:
	if !_micro_game_loop:
		return
	
	_gameover_label_score.text = "SCORE: %d" % [_micro_game_iteration] 
	_micro_game_loop = false

func _on_current_microgame_completed(success: bool) -> void:
	_micro_game_current.on_complete.disconnect(_on_current_microgame_completed)
	
	if !success:
		print("not successful, decrement lives")
		_lives -= 1
		# TODO: play life lost animation
	else:
		print("successful")
		# play some sort of success animation
	
	_animation_player.play(&"microgame_exit")
	await _animation_player.animation_finished
	
	if _lives <= 0:
		print("game over")
		_gameover_animation_player.play(&"gameover_enter")
		loop_stop()
	else:
		_set_next_microgame()

func _set_next_microgame() -> void:
	_micro_game_iteration += 1
	
	_micro_game_current = micro_games[_micro_game_iteration % micro_games.size()]
	_micro_game_current.on_complete.connect(_on_current_microgame_completed)
	
	for micro_game: MicroGame in micro_games:
		if micro_game == _micro_game_current:
			micro_game.visible = true
		else:
			micro_game.visible = false
	
	# TODO: await for animation?
	
	_animation_player.play(&"microgame_enter")
	await _animation_player.animation_finished
	
	_micro_game_current.start(micro_game_time_scale_curve.sample(float(_micro_game_iteration)))
