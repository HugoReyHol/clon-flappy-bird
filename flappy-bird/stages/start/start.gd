extends Node2D


signal change_scene_requested(new_scene)

const GAME_SCENE: String = "res://stages/game/game.tscn"

@export var options_button: Button
@export var anim_player: AnimationPlayer
@export var replay_button: TextureButton
@export var options_menu: OptionMenu


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


# Desactiva los botones y muestra el menu de opciones
func _on_options_button_up() -> void:
	options_menu.show_ui()
	replay_button.disabled = true
	options_button.disabled = true


# Activa los botones cuando se cierra el menu de opciones
func _on_options_closed() -> void:
	replay_button.disabled = false
	options_button.disabled = false
