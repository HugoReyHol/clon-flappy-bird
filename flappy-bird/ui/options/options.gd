class_name OptionMenu
extends Control


signal closed

@export var cont: MarginContainer
@export var patchRect: NinePatchRect
@export var master_slider: VolumeSlider
@export var music_slider: VolumeSlider
@export var sfx_slider: VolumeSlider

var config_last: ConfigFile

@onready var center_pos: Vector2 = get_viewport().get_visible_rect().size/2.0 - cont.size/2.0
@onready var hidden_pos: Vector2 = Vector2(
	center_pos.x,
	get_viewport().get_visible_rect().size.y
)
@onready var master_bus: int = AudioServer.get_bus_index("Master")
@onready var music_bus: int = AudioServer.get_bus_index("Music")
@onready var sfx_bus: int = AudioServer.get_bus_index("SFX")


func _ready() -> void:
	_set_disable()
	patchRect.size = cont.size
	position = hidden_pos


func show_ui(show_now: bool = true) -> void:
	var tween: Tween = create_tween()
	
	if show_now:
		config_last = ConfigSaveHandler.config
		_set_controls_values()
		tween.tween_property(self, "position", center_pos, 0.5)
		tween.tween_callback(func() -> void: _set_disable(false))
	else:
		_set_disable()
		tween.tween_property(self, "position", hidden_pos, 0.5)
	
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


# Le da los valores correctos a los elementos de la ui
func _set_controls_values() -> void:
	var volume_settings := ConfigSaveHandler.load_settings(SettingsKeys.volume)
	var user_settings := ConfigSaveHandler.load_settings(SettingsKeys.user)
	
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


# Cierra el menu de opciones sin guardar y restaura los valores de los buses de audio
func _on_cancel_button_up() -> void:
	ConfigSaveHandler.config = config_last
	
	var volume_settings := ConfigSaveHandler.load_settings(SettingsKeys.volume)
	
	AudioServer.set_bus_mute(master_bus, volume_settings[SettingsKeys.master_mute])
	AudioServer.set_bus_volume_linear(master_bus, volume_settings[SettingsKeys.master_vol])
	AudioServer.set_bus_mute(music_bus, volume_settings[SettingsKeys.music_mute])
	AudioServer.set_bus_volume_linear(music_bus, volume_settings[SettingsKeys.music_vol])
	AudioServer.set_bus_mute(sfx_bus, volume_settings[SettingsKeys.sfx_mute])
	AudioServer.set_bus_volume_linear(sfx_bus, volume_settings[SettingsKeys.sfx_vol])
	
	show_ui(false)
	closed.emit()


# Guarda los cambios realizados
func _on_save_button_up() -> void:
	ConfigSaveHandler.save()
	show_ui(false)
	closed.emit()


func _on_master_slider_muted_pressed(muted: bool) -> void:
	ConfigSaveHandler.set_setting(
		SettingsKeys.volume,
		SettingsKeys.master_mute,
		muted
	)
	
	AudioServer.set_bus_mute(master_bus, muted)


func _on_master_slider_value_changed(value: float) -> void:
	ConfigSaveHandler.set_setting(
		SettingsKeys.volume,
		SettingsKeys.master_vol,
		value
	)
	
	AudioServer.set_bus_volume_linear(master_bus, value)


func _on_music_slider_muted_pressed(muted: bool) -> void:
	ConfigSaveHandler.set_setting(
		SettingsKeys.volume,
		SettingsKeys.music_mute,
		muted
	)
	
	AudioServer.set_bus_mute(music_bus, muted)


func _on_music_slider_value_changed(value: float) -> void:
	ConfigSaveHandler.set_setting(
		SettingsKeys.volume,
		SettingsKeys.music_vol,
		value
	)
	
	AudioServer.set_bus_volume_linear(music_bus, value)


func _on_sfx_slider_muted_pressed(muted: bool) -> void:
	ConfigSaveHandler.set_setting(
		SettingsKeys.volume,
		SettingsKeys.sfx_mute,
		muted
	)
	
	AudioServer.set_bus_mute(sfx_bus, muted)


func _on_sfx_slider_value_changed(value: float) -> void:
	ConfigSaveHandler.set_setting(
		SettingsKeys.volume,
		SettingsKeys.sfx_vol,
		value
	)
	
	AudioServer.set_bus_volume_linear(sfx_bus, value)


func _on_log_out_button_up() -> void:
	ConfigSaveHandler.set_setting(
		SettingsKeys.user,
		SettingsKeys.jwt,
		null
	)
	ConfigSaveHandler.set_setting(
		SettingsKeys.user,
		SettingsKeys.name,
		null
	)
	
