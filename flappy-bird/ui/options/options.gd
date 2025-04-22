class_name OptionMenu
extends Control


@export var cont: MarginContainer
@export var patchRect: NinePatchRect


func _ready() -> void:
	patchRect.size = cont.size
