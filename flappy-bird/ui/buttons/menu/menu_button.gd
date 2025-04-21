class_name GameMenuButton # MenuButton ya existe
extends TextureButton


signal menu_button_pressed


# Detecta los atajos de teclado
func _shortcut_input(event: InputEvent) -> void:
	if event.is_action("ui_cancel"):
		menu_button_pressed.emit()


# Detecta cuando se ha pulsado el boton
func _on_button_up() -> void:
	if is_hovered():
		menu_button_pressed.emit()
