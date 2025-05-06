class_name UserForm
extends Control


enum InitType {LOGUP, LOGIN}

const MARGIN_SIZE: int = 10

@export var data_form: VBoxContainer
@export var patch: NinePatchRect

var init_type: InitType
var center_pos: Vector2
var hidden_pos: Vector2


func _ready() -> void:
	var margins: Vector2 = Vector2.ONE * MARGIN_SIZE
	data_form.position = margins
	patch.size = data_form.size + margins * 2
	
	center_pos = (get_viewport().get_visible_rect().size - patch.size) / 2
	hidden_pos = Vector2(center_pos.x, get_viewport().get_visible_rect().size.y)
	
	patch.position = center_pos
