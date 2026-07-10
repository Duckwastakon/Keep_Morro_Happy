extends Node

var config = ConfigFile.new()
const SETTINGS_FILE_PATH = "user://settings.ini"

func setup() -> void:
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
	if config.has_section("main"):
		return config.get_value("main", key)
	else:
		setup()
		return loadSetting(key)


#Settings
var mouseThrow = true

var sfxVolume = loadSetting("sfxVolume")
var musicVolume = loadSetting("musicVolume")
var screenShake = loadSetting("screenShake")

const itemPullSpeed = 100
const throwSpeed = 500
const cleanTime = 3

var difficulty = "beginner"

var difficulties = {
	"beginner" = {
		gameTime = 180,
		petDesireTimer = 55,
		mapSize = Vector2(1152, 672),
		taskAmount = 3,
		morroTime = 30,
		morroNeeds = 10,
		wireAmount = 3,
		mathAmount = 2,
	},
	"normal" = {
		gameTime = 160,
		petDesireTimer = 45,
		mapSize = Vector2(1152, 672),
		taskAmount = 4,
		morroTime = 22,
		morroNeeds = 8,
		wireAmount = 5,
		mathAmount = 3,
	},
	"hard" = {
		gameTime = 150,
		petDesireTimer = 35,
		mapSize = Vector2(1152, 672),
		taskAmount = 5,
		morroTime = 16,
		morroNeeds = 7,
		wireAmount = 6,
		mathAmount = 4,
	},
	"impossible" = {
		gameTime = 180,
		petDesireTimer = 25,
		mapSize = Vector2(1152, 672),
		taskAmount = 8,
		morroTime = 10,
		morroNeeds = 6,
		wireAmount = 8,
		mathAmount = 4,
	},
	"speed" = {
		gameTime = 90,
		petDesireTimer = 30,
		mapSize = Vector2(1152, 672),
		taskAmount = 3,
		morroTime = 11,
		morroNeeds = 5,
		wireAmount = 5,
		mathAmount = 3,
	},
}

const tasks = ["books", "wires", "cleaning", "homework", "poop", "coffee", "dishes"]

const Items = {
	0: {
		"sprite": "res://Assets/Art/trashBag.png",
		"name": "Trash bag",
		"scale": 2,
	},
	1: {
		"Sprite": "",
		"name": "Water bottle",
		"scale": 1,
	},
	2: {
		"sprite": "res://Assets/Art/food.png",
		"name": "Cat food",
		"scale": 1.5,
	},
	3: {
		"sprite": "res://Assets/Art/dirtyTrashbag.png",
		"name": "Dirty bag",
		"scale": 2,
	},
	4: {
		"sprite": "res://Assets/Art/broom.png",
		"name": "Broom",
		"scale": 2,
	},
	5: {
		"sprite": "res://Assets/Art/book.png",
		"name": "Book",
		"scale": 1.5,
	},
}
