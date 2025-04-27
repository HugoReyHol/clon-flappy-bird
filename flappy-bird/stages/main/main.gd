extends Node2D


const INITIAL_STAGE: String = "res://stages/start/start.tscn"

@export var options: OptionMenu

var stage: Node2D
var options_open: bool = false


# Precarga la escena elegida en la constante y conecta su señal de cambio de escena
func _init() -> void:
	var stage_res: PackedScene = load(INITIAL_STAGE)
	stage = stage_res.instantiate()
	
	if stage.has_signal("change_scene_requested"):
		stage.connect("change_scene_requested", _change_scene)
	
	add_child(stage)


# Maneja las teclas pulsadas por el usuario
func _input(event: InputEvent) -> void:
	if event.is_action("ui_cancel"):
		get_tree().quit()
	
	if event.is_action_pressed("ui_cancel"):
		options_open = not options_open
		options.show_ui(options_open)
		print(options_open)


# Cambia la escena actual por la pedida en su señal de cambio
func _change_scene(new_scene: String) -> void:
	var new_scene_res: PackedScene = load(new_scene)
	
	# Elimina la escena existente
	stage.disconnect("change_scene_requested", _change_scene)
	remove_child(stage)
	stage.queue_free()
	
	# Carga la nueva en el arbol de nodos
	stage = new_scene_res.instantiate()
	if stage.has_signal("change_scene_requested"):
		stage.connect("change_scene_requested", _change_scene)
	add_child(stage)
