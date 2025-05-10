extends Node2D


const INITIAL_STAGE: String = "res://stages/start/start.tscn"
const SNACK_BAR: PackedScene = preload("res://ui/snackbar/snackbar.tscn")
const SNACK_BAR_POS = Vector2(144, 516)

@export var canvas_layer: CanvasLayer

var stage: Node2D
var options_open: bool = false
var snack_bar: SnackBar


# Precarga la escena elegida en la constante y conecta su señal de cambio de escena
func _ready() -> void:
	Supabase.auth.error.connect(_on_error)
	
	var stage_res: PackedScene = load(INITIAL_STAGE)
	stage = stage_res.instantiate()
	
	if stage.has_signal("change_scene_requested"):
		stage.connect("change_scene_requested", _change_scene)
	
	add_child(stage)


# Maneja las teclas pulsadas por el usuario
func _input(event: InputEvent) -> void:
	if event.is_action("ui_cancel"):
		get_tree().quit()


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


# Muestra el mensaje de error en el snackbar
func _on_error(error: SupabaseAuthError) -> void:
	print(error.code)
	print(error.message)
	
	var msg: String
	match error.message:
		"missing email or phone":
			msg = tr("ERR_LIN_VACIO")
		
		"Invalid login credentials":
			msg = tr("ERR_LIN_INCOR")
		
		"Anonymous sign-ins are disabled":
			msg = tr("ERR_LUP_VACIO")
		
		"Signup requires a valid password":
			msg = tr("ERR_LUP_INCOR")
		
		"Password should be at least 6 characters.":
			msg = tr("ERR_LUP_MEN6")
		
		"User already registered":
			msg = tr("ERR_LUP_UEXIS")
		
		_:
			msg = error.message
	
	if snack_bar != null:
		snack_bar.queue_free()
	
	snack_bar = SNACK_BAR.instantiate()
	canvas_layer.add_child(snack_bar)
	
	snack_bar.position = SNACK_BAR_POS
	snack_bar.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	snack_bar.show_msg(msg)
