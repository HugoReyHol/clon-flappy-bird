class_name UserForm
extends Control


signal closed

enum LogType {LOGUP, LOGIN, NONE}

const MARGIN_SIZE: int = 10

@export var data_form: VBoxContainer
@export var patch: NinePatchRect
@export var email_line: LineEdit
@export var password_line: LineEdit
@export var cancel_button: Button
@export var accept_button: Button
@export var title_label: Label
@export var email_label: Label
@export var pass_label: Label

var log_type: LogType
var center_pos: Vector2
var hidden_pos: Vector2


# Configuracion inicial de UserForm
func _ready() -> void:
	Supabase.auth.error.connect(_on_error)
	Supabase.auth.signed_in.connect(_on_supabase_task_ended)
	Supabase.auth.signed_up.connect(_on_supabase_task_ended)
	
	data_form.position = Vector2.ONE * MARGIN_SIZE
	
	email_label.text = tr("EMAIL_LOG") + ":"
	pass_label.text = tr("PASS_LOG") + ":"


# Muestro o esconde la interfaz
func show_ui(show_now: bool = true, new_log: LogType = LogType.NONE) -> void:
	if show_now:
		log_type = new_log
		title_label.text = tr("LOG_IN") if log_type == LogType.LOGIN else tr("LOG_UP")
		await get_tree().process_frame
		_resize_patch()
	
	var tween: Tween = create_tween()
	
	if show_now:
		email_line.clear()
		password_line.clear()
		tween.tween_property(self, "position", center_pos, 0.5)
		tween.tween_callback(func() -> void: _set_disable(false))
	else:
		_set_disable()
		tween.tween_property(self, "position", hidden_pos, 0.5)
		tween.tween_callback(func() -> void: closed.emit())
	
	tween.play()


# Cambia el tamaño de patch y la posicion oculta y centrada
func _resize_patch() -> void:
	patch.size = data_form.size + Vector2.ONE * MARGIN_SIZE * 2
	
	center_pos = (get_viewport().get_visible_rect().size - patch.size) / 2
	hidden_pos = Vector2(center_pos.x, get_viewport().get_visible_rect().size.y)
	
	position = hidden_pos


# Borra la contraseña y habilita los controles al detectar un error
func _on_error(_error: SupabaseAuthError) -> void:
	password_line.clear()
	_set_disable(false)


# Deshabilita o habilita los controles
func _set_disable(disable: bool = true) -> void:
	email_line.editable = not disable
	password_line.editable = not disable
	accept_button.disabled = disable
	cancel_button.disabled = disable


# Si el inicio acaba correctamente cierra el formulario
func _on_supabase_task_ended(_user: SupabaseUser) -> void:
	print("Acabado")
	show_ui(false)


# Cancela el inicio de sesion
func _on_cancel_button_up() -> void:
	if cancel_button.is_hovered():
		show_ui(false)


# Inicia el registro o inicio de sesion
func _on_accept_button_up() -> void:	
	if not accept_button.is_hovered():
		return
	
	_set_disable()
	
	match log_type:
		LogType.LOGUP:
			Supabase.auth.sign_up(email_line.text, password_line.text)
		
		LogType.LOGIN:
			Supabase.auth.sign_in(email_line.text, password_line.text)
		
		_ :
			show_ui(false)
