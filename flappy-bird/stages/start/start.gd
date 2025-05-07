extends Node2D


signal change_scene_requested(new_scene)

const GAME_SCENE: String = "res://stages/game/game.tscn"

@export var options_button: Button
@export var anim_player: AnimationPlayer
@export var replay_button: TextureButton
@export var options_menu: OptionMenu
@export var exit_button: Button
@export var log_up_button: Button
@export var log_in_button: Button
@export var user_form: UserForm


func _ready() -> void:
	exit_button.visible = not OS.has_feature("android")


# Detecta los atajos de teclado
func _shortcut_input(event: InputEvent) -> void:
	if event.is_action("ui_accept") and not replay_button.disabled:
		anim_player.play("change_to_game")


# Envia la señal cuando se activa el boton
func change_scene() -> void:
	change_scene_requested.emit(GAME_SCENE)


func _disable_buttons(disable: bool = true) -> void:
	replay_button.disabled = disable
	options_button.disabled = disable
	exit_button.disabled = disable
	log_up_button.disabled = disable
	log_in_button.disabled = disable

# Detecta los clics del usuario
func _on_replay_button_button_up() -> void:
	if replay_button.is_hovered():
		anim_player.play("change_to_game")    


# Desactiva los botones y muestra el menu de opciones
func _on_options_button_up() -> void:
	if options_button.is_hovered():
		options_menu.show_ui()
		_disable_buttons()


# Activa los botones cuando se cierra el menu de opciones
func _on_options_closed() -> void:
	_disable_buttons(false)


# Cierra el juego
func _on_exit_button_up() -> void:
	if exit_button.is_hovered():
		get_tree().quit()


# Abre el formulario de usuario para registrarse
func _on_log_up_button_up() -> void:
	if log_up_button.is_hovered():
		user_form.show_ui(true, UserForm.LogType.LOGUP)
		_disable_buttons()


# Abre el formulario de usuario para iniciar sesion
func _on_log_in_button_up() -> void:
	if log_in_button.is_hovered():
		user_form.show_ui(true, UserForm.LogType.LOGIN)
		_disable_buttons()


# Activa los botones cuando se cierra el menu
func _on_user_form_closed() -> void:
	_disable_buttons(false)
