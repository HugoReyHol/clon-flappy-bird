extends Node2D


signal change_scene_requested(new_scene)

const GAME_SCENE: String = "res://stages/game/game.tscn"

@export var options_button: Button
@export var anim_player: AnimationPlayer
@export var replay_button: TextureButton
@export var options_menu: OptionMenu
@export var exit_button: Button
@export var log_up_button: Button
@export var log_in_button: Button
@export var user_form: UserForm
@export var button_vbox: VBoxContainer


# Ajustes iniciales de start
func _ready() -> void:
	Supabase.auth.signed_in.connect(_on_log)
	Supabase.auth.signed_up.connect(_on_log)
	Supabase.auth.token_refreshed.connect(_on_log)
	Supabase.auth.signed_out.connect(_on_log_out)
	EventBus.locale_changed.connect(_on_locale_changed)
	
	if ConfigSaveHandler.loading_state == ConfigSaveHandler.LoadingState.LOADED:
		anim_player.play("show_buttons_auto")
	else:
		ConfigSaveHandler.config_ended.connect(_on_config_ended)
	
	_hide_log_buttons(Supabase.auth.client != null)
	
	exit_button.visible = not OS.has_feature("android")


# Detecta los atajos de teclado
func _shortcut_input(event: InputEvent) -> void:
	if event.is_action("ui_accept") and not replay_button.disabled:
		anim_player.play("change_to_game")


# Envia la señal cuando se activa el boton
func change_scene() -> void:
	change_scene_requested.emit(GAME_SCENE)


# Desahibila y habilita los botones del menu
func _disable_buttons(disable: bool = true) -> void:
	replay_button.disabled = disable
	options_button.disabled = disable
	exit_button.disabled = disable
	log_up_button.disabled = disable or Supabase.auth.client != null
	log_in_button.disabled = disable or Supabase.auth.client != null


# Reajusta el tamaño del contenedor de botones
func _reset_buttons_vbox() -> void:
	button_vbox.reset_size()
	await get_tree().process_frame
	button_vbox.position.x = (get_viewport().get_visible_rect().size.x - button_vbox.size.x) / 2.0


# Vuelve invisibles o visibles los botones de log
func _hide_log_buttons(new_hide: bool = true) -> void:
	log_up_button.visible = not new_hide
	log_in_button.visible = not new_hide
	
	_reset_buttons_vbox()


# Ajusta los botones cuando cambia el idioma
func _on_locale_changed() -> void:
	_reset_buttons_vbox()


# Detecta los clics del usuario
func _on_replay_button_button_up() -> void:
	if replay_button.is_hovered():
		anim_player.play("change_to_game")    


# Desactiva los botones y muestra el menu de opciones
func _on_options_button_up() -> void:
	if options_button.is_hovered():
		options_menu.show_ui()
		_disable_buttons()


# Activa los botones cuando se cierra el menu de opciones
func _on_options_closed() -> void:
	_disable_buttons(false)


# Cierra el juego
func _on_exit_button_up() -> void:
	if exit_button.is_hovered():
		get_tree().quit()


# Abre el formulario de usuario para registrarse
func _on_log_up_button_up() -> void:
	if log_up_button.is_hovered():
		user_form.show_ui(true, UserForm.LogType.LOGUP)
		_disable_buttons()


# Abre el formulario de usuario para iniciar sesion
func _on_log_in_button_up() -> void:
	if log_in_button.is_hovered():
		user_form.show_ui(true, UserForm.LogType.LOGIN)
		_disable_buttons()


# Activa los botones cuando se cierra el menu
func _on_user_form_closed() -> void:
	_disable_buttons(false)


# Oculta los botones cuando se inicia sesion
func _on_log(_user: SupabaseUser) -> void:
	_hide_log_buttons()


# Se muestran los botones cuando se cierra sesion
func _on_log_out() -> void:
	_hide_log_buttons(false)


# Muestra los botones cuando acaba de cargar el config
func _on_config_ended() -> void:
	anim_player.play("show_buttons")
