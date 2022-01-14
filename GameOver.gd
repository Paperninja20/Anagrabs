extends Node2D


var tile = preload("res://Tile.tscn")


var winMessage = "YOU WIN"
var loseMessage = "YOU LOSE"
var tieMessage = "TIE"
var tileArray = []

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	if Global.winner == 'P':
		won()
	elif Global.winner == 'O':
		lost()
	else:
		tied()

func won():
	var currX = 535
	var currY = 0
	for character in winMessage:
		if character == " ":
			currX += 100
			continue
		var randomTilt = rand_range(-30, 30)
		var newTile = tile.instance()
		newTile.tileLetter = character
		newTile.rotation_degrees = randomTilt
		newTile.position = Vector2(currX, currY)
		newTile.scale = Vector2(1.5, 1.5)
		tileArray.append(newTile)
		currX += 150
	for tile in tileArray:
		add_child(tile)
		var tween = tile.get_node("Tween")
		tween.interpolate_property(tile, "position", tile.position, tile.position + Vector2(0, rand_range(180, 210)), 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()
		yield(get_tree().create_timer(0.10), "timeout")

func lost():
	var currX = 460
	var currY = 0
	for character in loseMessage:
		if character == " ":
			currX += 100
			continue
		var randomTilt = rand_range(-30, 30)
		var newTile = tile.instance()
		newTile.tileLetter = character
		newTile.rotation_degrees = randomTilt
		newTile.position = Vector2(currX, currY)
		newTile.scale = Vector2(1.5, 1.5)
		tileArray.append(newTile)
		currX += 150
	for tile in tileArray:
		add_child(tile)
		var tween = tile.get_node("Tween")
		tween.interpolate_property(tile, "position", tile.position, tile.position + Vector2(0, rand_range(180, 210)), 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()
		yield(get_tree().create_timer(0.10), "timeout")

func tied():
	var currX = 810
	var currY = 0
	for character in tieMessage:
		if character == " ":
			currX += 100
			continue
		var randomTilt = rand_range(-30, 30)
		var newTile = tile.instance()
		newTile.tileLetter = character
		newTile.rotation_degrees = randomTilt
		newTile.position = Vector2(currX, currY)
		newTile.scale = Vector2(1.5, 1.5)
		tileArray.append(newTile)
		currX += 150
	for tile in tileArray:
		add_child(tile)
		var tween = tile.get_node("Tween")
		tween.interpolate_property(tile, "position", tile.position, tile.position + Vector2(0, rand_range(180, 210)), 0.25, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()
		yield(get_tree().create_timer(0.10), "timeout")

