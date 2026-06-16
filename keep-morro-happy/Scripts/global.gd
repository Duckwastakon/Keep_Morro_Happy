extends Node

#Settings
var mouseThrow = false
var sfxVolume = 50
var musicVolume = 50
var screenShake = 50

var mapSize = Vector2(1152, 648)

const itemPullSpeed = 100
const throwSpeed = 500
const cleanTime = 3

const tasks = ["books", "wires", "cleaning", "homework", "poop"]

const Items = {
	0: {
		"sprite": Color.BLACK,
		"name": "Trash bag",
	},
	1: {
		"Sprite": Color.BLUE,
		"name": "Water bottle",
	},
	2: {
		"sprite": Color.BROWN,
		"name": "Cat food",
	},
	3: {
		"sprite": Color.DARK_BLUE,
		"name": "Dirty bag",
	},
	4: {
		"sprite": Color.LIGHT_CORAL,
		"name": "Broom",
	},
	5: {
		"sprite": Color.WHITE,
		"name": "Book",
	},
}
