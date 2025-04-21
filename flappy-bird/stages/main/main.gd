extends Node2D

const INITIAL_STAGE: String = "res://stages/start/start.tscn"

var stage: Node2D


# Precarga la escena elegida en la constante y conecta su señal de cambio de escena
func _init() -> void:
	var stage_res: PackedScene = load(INITIAL_STAGE)
	stage = stage_res.instantiate()
	
	if stage.has_signal("change_scene_requested"):
		stage.connect("change_scene_requested", _change_scene)
	
	add_child(stage)


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
