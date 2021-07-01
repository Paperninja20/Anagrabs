extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var originPoint = [960, 440]
var lettersInPlay = []
var wordsInPlay = []

#8 tiles
var tileSlots = {
	[originPoint[0]      , originPoint[1] - 100]: null,
	[originPoint[0] + 75 , originPoint[1] - 75 ]: null,
	[originPoint[0] + 100, originPoint[1]      ]: null,
	[originPoint[0] + 75 , originPoint[1] + 75 ]: null,
	[originPoint[0]      , originPoint[1] + 100]: null,
	[originPoint[0] - 75 , originPoint[1] + 75 ]: null,
	[originPoint[0] - 100, originPoint[1]      ]: null,
	[originPoint[0] - 75 , originPoint[1] - 75] : null,
}

#6 tiles
"""var tileSlots = {
	[originPoint[0]      , originPoint[1] - 100]: null,
	[originPoint[0] + 86 , originPoint[1] - 50 ]: null,
	[originPoint[0] + 86 , originPoint[1] + 50 ]: null,
	[originPoint[0]      , originPoint[1] + 100]: null,
	[originPoint[0] - 86 , originPoint[1] + 50 ]: null,
	[originPoint[0] - 86 , originPoint[1] - 50] : null,
}"""

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func placeTile(tile):
	for key in tileSlots:
		if tileSlots[key] == null:
			tile.position.x = key[0]
			tile.position.y = key[1]
			tile.globalPos = Vector2(key[0], key[1])
			tileSlots[key] = tile
			return true
	
	return false
	
func removeTile(tile):
	for key in tileSlots:
		if tileSlots[key] == tile:
			tileSlots[key] = null
			break
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
