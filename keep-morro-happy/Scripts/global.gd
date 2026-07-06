extends Node

#Settings
var mouseThrow = false
var sfxVolume = 50
var musicVolume = 50
var screenShake = 50

var mapSize = Vector2(1152, 672)

const itemPullSpeed = 100
const throwSpeed = 500
const cleanTime = 3
const petDesireTimer = 40
var gameTime = 10

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
