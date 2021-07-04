extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tile = preload("res://Tile.tscn")
var alphabet = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z']

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is Sprite or child is Timer or child is Label:
			continue
		if child.name == "OptionsScene":
			continue
		var tween = child.get_node("Tween")
		tween.interpolate_property(child, "position", child.position, child.position + Vector2(0, 300), 0.12, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		tween.start()
		yield(get_tree().create_timer(0.11), "timeout")
	yield(get_tree().create_timer(0.11), "timeout")
	for child in get_children():
		if !(child is Label):
			continue
		var tween = Tween.new()
		tween.interpolate_property(child, "rect_position", child.rect_position, child.rect_position - Vector2(0, 680), 0.12, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		child.add_child(tween)
		tween.start()
				
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_TileTimer_timeout():
	for child in get_children():
		if child is Node2D:
			if child.position.y > 1080:
				child.queue_free()
	var diceRoll = randi()%3
	var randomX = rand_range(25, 1895)
	var randomLetter = alphabet[randi()%26]
	var newTile = tile.instance()
	var randomTilt = rand_range(-60, 60)
	newTile.get_node("Sprite").modulate.a = 0.5
	newTile.z_index = -1
	newTile.rotation_degrees = randomTilt
	if diceRoll == 1:
		newTile.tileLetter = ''
	else:
		newTile.tileLetter = randomLetter
	newTile.scale = Vector2(0.75, 0.75)
	newTile.position = Vector2(randomX, 0)
	add_child(newTile)
	var tween = newTile.get_node("Tween")
	tween.interpolate_property(newTile, "position", newTile.position, Vector2(randomX, 1081), 5, Tween.TRANS_LINEAR)
	tween.start()
	pass # Replace with function body.
