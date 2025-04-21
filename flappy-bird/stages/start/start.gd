extends Node2D


signal change_scene_requested(new_scene)

const GAME_SCENE: String = "res://stages/game/game.tscn"

@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var replay_button: TextureButton = $CanvasLayer/ReplayButton


# Detecta los atajos de teclado
func _shortcut_input(event: InputEvent) -> void:
	if event.is_action("ui_accept"):
		anim_player.play("change_to_game")


# Envia la señal cuando se activa el boton
func change_scene() -> void:
	change_scene_requested.emit(GAME_SCENE)


# Detecta los clics del usuario
func _on_replay_button_button_up() -> void:
	if replay_button.is_hovered():
		anim_player.play("change_to_game")    
