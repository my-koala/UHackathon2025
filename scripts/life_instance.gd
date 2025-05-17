@tool
extends Control
class_name LifeInstance

@onready
var _texture_dead: TextureRect = $dead as TextureRect

@onready
var _animation_player: AnimationPlayer = $animation_player as AnimationPlayer

var _dead: bool = false

func is_dead() -> bool:
	return _dead

func make_dead() -> void:
	_texture_dead.visible = true
	_dead = true
	_animation_player.play(&"dead_start")

func make_dead_not() -> void:
	_texture_dead.visible = false
	_dead = false
	_animation_player.play(&"dead_stop")

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	_texture_dead.visible = false
