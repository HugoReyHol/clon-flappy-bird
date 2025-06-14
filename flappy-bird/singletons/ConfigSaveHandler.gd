extends Node


signal config_ended

enum LoadingState {READING, LOADING, LOADED}

const SETTINGS_FILE_PATH: String = "user://settings.ini"

var config: ConfigFile = ConfigFile.new()
var loading_state: LoadingState = LoadingState.READING

@onready var master_bus: int = AudioServer.get_bus_index("Master")
@onready var music_bus: int = AudioServer.get_bus_index("Music")
@onready var sfx_bus: int = AudioServer.get_bus_index("SFX")


# Genera el archivo de configuracion o lo carga si ya existe uno
func _ready() -> void:
	Supabase.auth.error.connect(_on_error)
	Supabase.auth.token_refreshed.connect(_on_user_log)
	Supabase.auth.signed_out.connect(_on_log_out)
	Supabase.auth.signed_in.connect(_on_user_log)
	Supabase.auth.signed_up.connect(_on_user_log)
	
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value(SettingsKeys.volume, SettingsKeys.master_vol, 0.5)
		config.set_value(SettingsKeys.volume, SettingsKeys.master_mute, false)
		config.set_value(SettingsKeys.volume, SettingsKeys.music_vol, 0.5)
		config.set_value(SettingsKeys.volume, SettingsKeys.music_mute, false)
		config.set_value(SettingsKeys.volume, SettingsKeys.sfx_vol, 0.5)
		config.set_value(SettingsKeys.volume, SettingsKeys.sfx_mute, false)
		
		config.set_value(SettingsKeys.user, SettingsKeys.jwt, "")
		
		var user_locale: String = OS.get_locale_language()
		config.set_value(
			SettingsKeys.user, 
			SettingsKeys.locale,
			user_locale if 
				user_locale in SettingsKeys.supported_locales 
				else SettingsKeys.default_locale
		)
		
		config.save(SETTINGS_FILE_PATH)
		loading_state = LoadingState.LOADED
		config_ended.emit()
	
	else:
		load_config()
		
		# Inicia sesion a partir del jwt almacenado
		var jwt := str(config.get_value(SettingsKeys.user, SettingsKeys.jwt))
		if not jwt.is_empty():
			loading_state = LoadingState.LOADING
			Supabase.auth.refresh_token(jwt, 10.5)
		
		else:
			loading_state = LoadingState.LOADED
			config_ended.emit()


# Guarda un nuevo valor en las variables de config
func set_setting(section: String, key: String, value: Variant) -> void:
	config.set_value(section, key, value)


# Guarda la configuracion
func save() -> void:
	config.save(SETTINGS_FILE_PATH)


# Obtiene los valores y configura los buses
func load_config() -> void:
	config.load(SETTINGS_FILE_PATH)
	
	var volume_settings := get_settings(SettingsKeys.volume)
	
	AudioServer.set_bus_mute(master_bus, volume_settings[SettingsKeys.master_mute])
	AudioServer.set_bus_volume_linear(master_bus, volume_settings[SettingsKeys.master_vol])
	AudioServer.set_bus_mute(music_bus, volume_settings[SettingsKeys.music_mute])
	AudioServer.set_bus_volume_linear(music_bus, volume_settings[SettingsKeys.music_vol])
	AudioServer.set_bus_mute(sfx_bus, volume_settings[SettingsKeys.sfx_mute])
	AudioServer.set_bus_volume_linear(sfx_bus, volume_settings[SettingsKeys.sfx_vol])
	
	var user_settings := get_settings(SettingsKeys.user)
	
	TranslationServer.set_locale(user_settings[SettingsKeys.locale])
	EventBus.locale_changed.emit()


# Obtiene los valores de una seccion
func get_settings(section: String) -> Dictionary[String, Variant]:
	var settings: Dictionary[String, Variant] = {}
	for key in config.get_section_keys(section):
		settings[key] = config.get_value(section, key)
	return settings


# Metodo para borrar el token del archivo guardado
func _on_log_out() -> void:
	config.set_value(SettingsKeys.user, SettingsKeys.jwt, "")
	
	var temp_config: ConfigFile = ConfigFile.new()
	temp_config.load(SETTINGS_FILE_PATH)
	
	temp_config.set_value(SettingsKeys.user, SettingsKeys.jwt, "")
	temp_config.save(SETTINGS_FILE_PATH)


# Metodo para guardar el usuario cuando inicie sesion
func _on_user_log(user: SupabaseUser) -> void:
	config.set_value(SettingsKeys.user, SettingsKeys.jwt, user.refresh_token)
	config.save(SETTINGS_FILE_PATH)
	
	if loading_state == LoadingState.LOADING:
		loading_state = LoadingState.LOADED
		config_ended.emit()


func _on_error(_error: SupabaseAuthError) -> void:
	config.set_value(SettingsKeys.user, SettingsKeys.jwt, "")
	config.save(SETTINGS_FILE_PATH)
	config_ended.emit()
