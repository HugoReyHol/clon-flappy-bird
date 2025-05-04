extends Node


const SETTINGS_FILE_PATH: String = "user://settings.ini"

var config: ConfigFile = ConfigFile.new()

@onready var master_bus: int = AudioServer.get_bus_index("Master")
@onready var music_bus: int = AudioServer.get_bus_index("Music")
@onready var sfx_bus: int = AudioServer.get_bus_index("SFX")


# Genera el archivo de configuracion o lo carga si ya existe uno
func _ready() -> void:
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value(SettingsKeys.volume, SettingsKeys.master_vol, 0.5)
		config.set_value(SettingsKeys.volume, SettingsKeys.master_mute, false)
		config.set_value(SettingsKeys.volume, SettingsKeys.music_vol, 0.5)
		config.set_value(SettingsKeys.volume, SettingsKeys.music_mute, false)
		config.set_value(SettingsKeys.volume, SettingsKeys.sfx_vol, 0.5)
		config.set_value(SettingsKeys.volume, SettingsKeys.sfx_mute, false)
		
		config.set_value(SettingsKeys.user, SettingsKeys.jwt, null)
		config.set_value(SettingsKeys.user, SettingsKeys.name, null)
		
		var user_locale: String = OS.get_locale_language()
		config.set_value(
			SettingsKeys.user, 
			SettingsKeys.locale,
			user_locale if 
				user_locale in SettingsKeys.supported_locales 
				else SettingsKeys.default_locale
		)
		
		config.save(SETTINGS_FILE_PATH)
	
	else:
		config.load(SETTINGS_FILE_PATH)
		
		var volume_settings := ConfigSaveHandler.load_settings(SettingsKeys.volume)
		AudioServer.set_bus_mute(master_bus, volume_settings[SettingsKeys.master_mute])
		AudioServer.set_bus_volume_linear(master_bus, volume_settings[SettingsKeys.master_vol])
		AudioServer.set_bus_mute(music_bus, volume_settings[SettingsKeys.music_mute])
		AudioServer.set_bus_volume_linear(music_bus, volume_settings[SettingsKeys.music_vol])
		AudioServer.set_bus_mute(sfx_bus, volume_settings[SettingsKeys.sfx_mute])
		AudioServer.set_bus_volume_linear(sfx_bus, volume_settings[SettingsKeys.sfx_vol])


# Guarda un nuevo valor en las variables de config
func set_setting(section: String, key: String, value: Variant) -> void:
	config.set_value(section, key, value)


# Guarda la configuracion
func save() -> void:
	config.save(SETTINGS_FILE_PATH)


# Obtiene los valores de una seccion
func load_settings(section: String) -> Dictionary[String, Variant]:
	var settings: Dictionary[String, Variant] = {}
	for key in config.get_section_keys(section):
		settings[key] = config.get_value(section, key)
	return settings
