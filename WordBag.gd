extends Node2D

#144 tiles

"""var letters = {
		'A': 13,
		'B': 3, 
		'C': 3,
		'D': 6,
		'E': 18,
		'F': 3,
		'G': 4,
		'H': 3,
		'I': 12,
		'J': 2,
		'K': 2,
		'L': 5,
		'M': 3,
		'N': 8,
		'O': 11,
		'P': 3,
		'Q': 2,
		'R': 9,
		'S': 6,
		'T': 9,
		'U': 6,
		'V': 3,
		'W': 3,
		'X': 2,
		'Y': 3,
		'Z': 2
	}"""
	
var letters = {
		'A': 7,
		'B': 2, 
		'C': 2,
		'D': 3,
		'E': 9,
		'F': 3,
		'G': 2,
		'H': 2,
		'I': 6,
		'J': 1,
		'K': 1,
		'L': 3,
		'M': 2,
		'N': 4,
		'O': 6,
		'P': 2,
		'Q': 1,
		'R': 5,
		'S': 3,
		'T': 5,
		'U': 3,
		'V': 2,
		'W': 2,
		'X': 1,
		'Y': 2,
		'Z': 1
	}	
	
var letterBag = []
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tileCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("../TileShake").play()
	for letter in letters:
		var count = 0
		while count < letters[letter]:
			letterBag.append(letter)
			count += 1
	tileCount = letterBag.size()
	$TileCount.text = str(tileCount)
	pass # Replace with function body.

func updateTileCount(number):
	tileCount += number
	$TileCount.text = str(tileCount)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
