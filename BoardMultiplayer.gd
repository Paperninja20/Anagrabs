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
			#tile.position.x = key[0]
			#tile.position.y = key[1]
			tile.globalPos = Vector2(key[0], key[1])
			tileSlots[key] = tile
			return Vector2(key[0], key[1])
	
	return false
	
func replaceTile(firstKey, newTile):
	var replaceTile = tileSlots[firstKey]
	Server.tileDictionary.erase(replaceTile.tileID)
	Server.removeTileFromServerBoard(replaceTile.tileID)
	
	var replaceLetter = replaceTile.tileLetter
	var replaceTween = replaceTile.get_node("Tween")
	replaceTween.interpolate_property(replaceTile, "position", Vector2(firstKey[0], firstKey[1]), Vector2(960, 420), 0.15, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	replaceTween.interpolate_property(replaceTile, "scale", Vector2(0.5, 0.5), Vector2(0.25, 0.25), 0.15, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	replaceTween.start()
	
	yield(replaceTween, "tween_completed")
	replaceTile.get_parent().remove_child(replaceTile)
	yield(get_tree().create_timer(0.15), "timeout")
		
	get_node("../WordBag").letterBag.append(replaceTile.tileLetter)
	tileSlots[firstKey] = null
	placeTile(newTile)
	add_child(newTile)
	var tween = newTile.get_node("Tween")
	tween.interpolate_property(newTile, "position", Vector2(960, 420), Vector2(firstKey[0], firstKey[1]), 0.2, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.interpolate_property(newTile, "scale", Vector2(0.25, 0.25), Vector2(0.5, 0.5), 0.2, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	var lettersOut = []
	for tile in get_children():
		if !(tile is Node2D):
			continue
		lettersOut.append(tile.tileLetter)
	pass
	
	
func removeTile(tile):
	for key in tileSlots:
		if tileSlots[key] == tile:
			tileSlots[key] = null
			break
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
