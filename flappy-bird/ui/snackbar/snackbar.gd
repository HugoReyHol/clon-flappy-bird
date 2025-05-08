class_name SnackBar
extends Control


const MARGIN_SIZE_Y: int = 4
const MARGIN_SIZE_X: int = 10

@export var patch_rect: NinePatchRect
@export var snack_label: Label
@export var show_margin: int = 40
@export var snackbar_duration: float = 7.0


# Metodo para mostrar mensajes en la snackbar
func show_msg(msg: String) -> void:
	if msg == null or msg.is_empty():
		return
	
	snack_label.text = msg
	_anim_play()


# Ajusta el tamaño del fondo al texto
func _set_patch_size() -> void:
	patch_rect.size.x = snack_label.size.x + MARGIN_SIZE_X
	patch_rect.size.y = snack_label.size.y + MARGIN_SIZE_Y
	patch_rect.global_position.x = (get_viewport().get_visible_rect().size.x - patch_rect.size.x) / 2.0


# Muestra y oculta la snackbar
func _anim_play() -> void:
	var tween: Tween = create_tween()
	
	var original_pos: Vector2 = position
	
	tween.tween_property(self, "position", Vector2(position.x, position.y - show_margin), 0.3 )
	tween.tween_property(self, "position", original_pos, 0.3).set_delay(snackbar_duration)
	
	tween.play()


func _on_label_resized() -> void:
	_set_patch_size()
