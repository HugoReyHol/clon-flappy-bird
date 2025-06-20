class_name OptionMenu
extends Control


signal closed

const MARGIN_AREA: int = 10

@export var patch_rect: NinePatchRect
@export var master_slider: VolumeSlider
@export var music_slider: VolumeSlider
@export var sfx_slider: VolumeSlider
@export var audio_player: AudioStreamPlayer
@export var volume_lbl: Label
@export var user_lbl: Label
@export var lang_lbl: Label
@export var lang_opt: OptionButton
@export var sesion_lbl: Label
@export var log_out_btn: Button
@export var v_box: VBoxContainer

var vis: bool = false

@onready var center_pos: Vector2 = (
	get_viewport().get_visible_rect().size 
	- v_box.size 
	- Vector2.ONE * MARGIN_AREA *2
) / 2.0
@onready var hidden_pos: Vector2 = Vector2(
	center_pos.x,
	get_viewport().get_visible_rect().size.y
)
@onready var master_bus: int = AudioServer.get_bus_index("Master")
@onready var music_bus: int = AudioServer.get_bus_index("Music")
@onready var sfx_bus: int = AudioServer.get_bus_index("SFX")


# Configuron inicial del menu
func _ready() -> void:
	Supabase.auth.signed_out.connect(_set_user_controls_values)
	EventBus.locale_changed.connect(_on_locale_changed)
	
	_set_labels()
	
	for index in SettingsKeys.supported_languages.size():
		lang_opt.add_item(SettingsKeys.supported_languages[index], index)
	
	_set_disable()
	_on_options_container_resized()


# Muestro o esconde la interfaz
func show_ui(show_now: bool = true) -> void:
	var tween: Tween = create_tween()
	
	if show_now:
		_set_sound_controls_values()
		_set_user_controls_values()
		tween.tween_property(self, "position", center_pos, 0.5)
		tween.tween_callback(func() -> void: _set_disable(false))
	else:
		_set_disable()
		tween.tween_property(self, "position", hidden_pos, 0.5)
	
	tween.play()
	vis = show_now


# Habilita/Deshabilita los nodos interactuables de la interfaz
func _set_disable(disable: bool = true) -> void:
	var childs: Array[Node] = v_box.get_children()
	
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


# Le da los valores correctos a los elementos de la ui de sonido
func _set_sound_controls_values() -> void:
	var volume_settings := ConfigSaveHandler.get_settings(SettingsKeys.volume)
	
	master_slider.set_values(
		volume_settings[SettingsKeys.master_vol],
		volume_settings[SettingsKeys.master_mute]
	)
	
	music_slider.set_values(
		volume_settings[SettingsKeys.music_vol],
		volume_settings[SettingsKeys.music_mute]
	)
	
	sfx_slider.set_values(
		volume_settings[SettingsKeys.sfx_vol],
		volume_settings[SettingsKeys.sfx_mute]
	)


# Muestra o no el apartado de usuario si hay uno conectado
func _set_user_controls_values() -> void:
	var view_log_out: bool = Supabase.auth.client != null
	sesion_lbl.visible = view_log_out
	log_out_btn.visible = view_log_out
	
	_set_language()
	
	v_box.reset_size()


# Carga el idioma seleccionado
func _set_language() -> void:
	var user_settings := ConfigSaveHandler.get_settings(SettingsKeys.user)
	var loc: String = user_settings[SettingsKeys.locale]
	var index: int = SettingsKeys.supported_locales.find(loc)
	
	lang_opt.select(index)


# Configura el texto de los titulos de secciones
func _set_labels() -> void:
	volume_lbl.text = tr("VOLUME_SECT") + ":"
	user_lbl.text = tr("USER_SECT") + ":"


# Ajusta el tamaño del menú cuando cambia el idioma
func _on_locale_changed() -> void:
	_set_labels()
	v_box.reset_size()


# Cierra el menu de opciones sin guardar y restaura los valores anteriores
func _on_cancel_button_up() -> void:
	ConfigSaveHandler.load_config()
	v_box.reset_size()
	show_ui(false)
	closed.emit()


# Guarda los cambios realizados
func _on_save_button_up() -> void:
	ConfigSaveHandler.save()
	show_ui(false)
	closed.emit()


# Mutea Master
func _on_master_slider_muted_pressed(muted: bool) -> void:
	ConfigSaveHandler.set_setting(
		SettingsKeys.volume,
		SettingsKeys.master_mute,
		muted
	)
	
	AudioServer.set_bus_mute(master_bus, muted)


# Cambia el volumen de Master
func _on_master_slider_value_changed(value: float) -> void:
	ConfigSaveHandler.set_setting(
		SettingsKeys.volume,
		SettingsKeys.master_vol,
		value
	)
	
	AudioServer.set_bus_volume_linear(master_bus, value)


# Mutea Music
func _on_music_slider_muted_pressed(muted: bool) -> void:
	ConfigSaveHandler.set_setting(
		SettingsKeys.volume,
		SettingsKeys.music_mute,
		muted
	)
	
	AudioServer.set_bus_mute(music_bus, muted)


# Cambia el volumen de Music
func _on_music_slider_value_changed(value: float) -> void:
	ConfigSaveHandler.set_setting(
		SettingsKeys.volume,
		SettingsKeys.music_vol,
		value
	)
	
	AudioServer.set_bus_volume_linear(music_bus, value)


# Mutea SFX
func _on_sfx_slider_muted_pressed(muted: bool) -> void:
	ConfigSaveHandler.set_setting(
		SettingsKeys.volume,
		SettingsKeys.sfx_mute,
		muted
	)
	
	AudioServer.set_bus_mute(sfx_bus, muted)


# Cambia el volumen de SFX
func _on_sfx_slider_value_changed(value: float) -> void:
	ConfigSaveHandler.set_setting(
		SettingsKeys.volume,
		SettingsKeys.sfx_vol,
		value
	)
	
	AudioServer.set_bus_volume_linear(sfx_bus, value)


# Al soltar el slider reproduce sonido de comprobación
func _on_slider_drag_ended() -> void:
	audio_player.play()


# Cierra la sesion borrando el jwt
func _on_log_out_button_up() -> void:
	# ConfigFile esta conectado a la señal emitida al cerrar sesion
	if log_out_btn.is_hovered():
		Supabase.auth.sign_out()


# Cambia el tamano del fondo cuando VBox cambia de tamano
func _on_options_container_resized() -> void:
	patch_rect.size = v_box.size + Vector2.ONE * MARGIN_AREA * 2
	
	center_pos = (get_viewport().get_visible_rect().size - patch_rect.size) / 2.0
	hidden_pos.x = center_pos.x
	
	position = center_pos if vis else hidden_pos


# Guarda el nuevo locale cuando cambia el idioma
func _on_lang_options_item_selected(index: int) -> void:
	var loc: String = SettingsKeys.supported_locales[index]
	ConfigSaveHandler.set_setting(SettingsKeys.user, SettingsKeys.locale, loc)
	TranslationServer.set_locale(loc)
	
	EventBus.locale_changed.emit()
