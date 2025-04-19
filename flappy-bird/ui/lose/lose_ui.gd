extends Control


@onready var anim_player: AnimationPlayer = $AnimationPlayer
@onready var replay_button: TextureButton = $ReplayButton


# Detecta cuando se activa el boton por teclado y reinicia
func _shortcut_input(event: InputEvent) -> void:
	if event.is_action("ui_accept") and not replay_button.disabled:
		get_tree().reload_current_scene()


# Funcion para mostrar la interfaz 
func show_ui() -> void:
	anim_player.play("show_lose_UI")


# Detecta cuando se pulsa el boton y reinicia
func _on_texture_button_up() -> void:
	if replay_button.is_hovered():
		get_tree().reload_current_scene()
