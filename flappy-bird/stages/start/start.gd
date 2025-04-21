extends Node2D


signal change_scene_requested

const GAME_SCENE: String = "res://stages/game/game.tscn"

@onready var anim_player: AnimationPlayer = $AnimationPlayer


func _shortcut_input(event: InputEvent) -> void:
	if event.is_action("ui_accept"):
		anim_player.play("change_to_game")

func change_scene() -> void:
	change_scene_requested.emit(GAME_SCENE)

func _on_replay_button_button_up() -> void:
	anim_player.play("change_to_game")    
