class_name OptionMenu
extends Control


@export var cont: MarginContainer
@export var patchRect: NinePatchRect

@onready var center_pos: Vector2 = get_viewport().get_visible_rect().size/2.0 - cont.size/2.0
@onready var hided_pos: Vector2 = Vector2(
	center_pos.x,
	get_viewport().get_visible_rect().size.y
)


func _ready() -> void:
	_set_disable()
	patchRect.size = cont.size
	position = hided_pos
	show_ui()


func show_ui(show_now: bool = true) -> void:
	var tween: Tween = create_tween()
	
	if show_now:
		tween.tween_property(self, "position", center_pos, 0.5)
		tween.tween_callback(func() -> void: _set_disable(false))
	else:
		_set_disable()
		tween.tween_property(self, "position", hided_pos, 0.5)
	
	tween.play()


# Habilita/Deshabilita los nodos interactuables de la interfaz
func _set_disable(disable: bool = true) -> void:	
	var childs: Array[Node] = cont.get_children()
	
	while not childs.is_empty():
		if childs[0] is Control:
			childs += childs[0].get_children()
			
			# Comprueba si se puede deshabilitar
			if "disabled" in childs[0]:
				childs[0].disabled = disable
			
			# Comprueba si se puede bloquear su edicion
			if "editable" in childs[0]:
				childs[0].editable = not disable
		
		childs.remove_at(0)
