extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var currentX = 0
var currentY = 0

func addWord(tileArray):
	#if (tileArray.size() * 40) + currentX > 1920:
	#	currentY += 60
	#	currentX = 80
	for tile in tileArray:
		var tween = tile.get_node("Tween")
		#print(str(tile.position.x) + " is old pos")
		#print(str(tile.position.y) + " is old pos")
		tween.interpolate_property(tile, "position", Vector2(tile.position.x, tile.position.y), Vector2(currentX, currentY), 1, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()
		#print(str(tile.position.x) + " is new pos")
		#print(str(tile.position.y) + " is new pos")
		currentX += 50
	currentX = 0
	currentY = 0
		
		

func arrangeWords():
	var currX = 50
	var currY = 700
	for word in self.get_children():
		if (word.word.length() * 50 + currX > 1920):
			currY += 75
			if currX == 50:
				currX = 100
			else:
				currX = 50
		word.position.x = currX
		word.position.y = currY
		currX += (word.word.length() * 50) + 70
		#lastOffset = (word.word.length() * 40) + 60
		
		
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
