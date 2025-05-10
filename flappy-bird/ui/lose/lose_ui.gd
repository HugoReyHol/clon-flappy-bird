extends Control


signal game_restarted
signal change_scene_requested(new_scene)

const MENU_SCENE = "res://stages/start/start.tscn"

@export var anim_player: AnimationPlayer
@export var replay_button: TextureButton
@export var buttons_cont: VBoxContainer


func _ready() -> void:
	buttons_cont.position.x = (
		get_viewport().get_visible_rect().size.x
		- buttons_cont.size.x
	) / 2.0
	pass


# Detecta cuando se activa el boton por teclado y reinicia
func _shortcut_input(event: InputEvent) -> void:
	if event.is_action("ui_accept") and not replay_button.disabled:
		game_restarted.emit()


# Funcion para mostrar la interfaz 
func show_ui(show_now: bool = true) -> void:
	if show_now:
		anim_player.play("show_lose_UI")
	else:
		anim_player.play("RESET")


# Detecta cuando se pulsa el boton y reinicia
func _on_texture_button_up() -> void:
	if replay_button.is_hovered():
		game_restarted.emit()


# Repite la señal a su nodo padre
func _on_menu_button_pressed() -> void:
	change_scene_requested.emit(MENU_SCENE)
