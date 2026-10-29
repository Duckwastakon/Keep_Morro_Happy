extends Node

var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"

var sfxVolume = 50
var musicVolume = 50
var screenShake = 50

func _ready() -> void:
	if !FileAccess.file_exists(SETTINGS_FILE_PATH):
		config.set_value("main", "sfxVolume", 50)
		config.set_value("main", "musicVolume", 50)
		config.set_value("main", "screenShake", 50)
		
		config.save(SETTINGS_FILE_PATH)
	else:
		config.load(SETTINGS_FILE_PATH)

func saveSetting(key, value):
	config.set_value("main", key, value)
	config.save(SETTINGS_FILE_PATH)

func loadSetting(key):
	return config.get_value("main", key)
