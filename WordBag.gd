extends Node2D

var letters = {
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
	}
	
var letterBag = []
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tileCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
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
