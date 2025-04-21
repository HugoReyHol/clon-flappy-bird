extends Node2D


@onready var anim_player: AnimationPlayer = $AnimationPlayer


func _shortcut_input(event: InputEvent) -> void:
	if event.is_action("ui_accept"):
		anim_player.play("change_to_game")

func change_scene() -> void:
	get_tree().change_scene_to_file("res://stages/game/game.tscn")

func _on_replay_button_button_up() -> void:
	anim_player.play("change_to_game")    
