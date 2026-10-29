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
var mouseThrow = false

var sfxVolume = loadSetting("sfxVolume")
var musicVolume = loadSetting("musicVolume")
var screenShake = loadSetting("screenShake")

const itemPullSpeed = 100
const throwSpeed = 500
const cleanTime = 3

var difficulty = "beginner"

var difficulties = {
	"beginner" = {
		gameTime = 300,
		petDesireTimer = 55,
		mapSize = Vector2(1152, 672),
		taskAmount = 2,
		morroTime = 45,
		morroNeeds = 20,
		wireAmount = 3,
		mathAmount = 2,
	},
	"normal" = {
		gameTime = 270,
		petDesireTimer = 50,
		mapSize = Vector2(1440, 672),
		taskAmount = 4,
		morroTime = 35,
		morroNeeds = 15,
		wireAmount = 4,
		mathAmount = 3,
	},
	"hard" = {
		gameTime = 240,
		petDesireTimer = 40,
		mapSize = Vector2(1440, 720),
		taskAmount = 6,
		morroTime = 30,
		morroNeeds = 9,
		wireAmount = 6,
		mathAmount = 4,
	},
	"impossible" = {
		gameTime = 180,
		petDesireTimer = 25,
		mapSize = Vector2(1728, 768),
		taskAmount = 8,
		morroTime = 20,
		morroNeeds = 7,
		wireAmount = 8,
		mathAmount = 4,
	},
	"speed" = {
		gameTime = 120,
		petDesireTimer = 30,
		mapSize = Vector2(1152, 672),
		taskAmount = 3,
		morroTime = 15,
		morroNeeds = 10,
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

const buildings = {
	0: {
		"buildingName": "chair",
		"price": 50,
		"functionality": "chair",
		"png": "res://Assets/Art/broom.png",
	},
	1: {
		"buildingName": "table1",
		"price": 50,
		"functionality": "table",
		"png": "res://Assets/Art/homeworkTable.png",
		"collision": true,
	},
}

var cash = 100

var mapData = []
