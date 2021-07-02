extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var currentX = 0
var currentY = 0
var animationSpeed = 0.5

func addWord(tileArray):
	for tile in tileArray:
		var tween = tile.get_node("Tween")

		tween.interpolate_property(tile, "position", tile.globalPos - tile.get_parent().position, Vector2(currentX, currentY), animationSpeed, Tween.TRANS_QUAD, Tween.EASE_IN)
		tween.interpolate_property(tile.get_parent(), "scale", Vector2(1, 1), Vector2(3, 3), animationSpeed, Tween.TRANS_QUAD, Tween.EASE_IN)
		tween.interpolate_property(tile.get_parent(), "position", tile.get_parent().position, 
			tile.get_parent().position - Vector2((tile.get_parent().widthToSubtract), (tile.get_parent().heightToSubtract)), animationSpeed, Tween.TRANS_QUAD, Tween.EASE_IN)
		tween.start()
		currentX += 50
	currentX = 0
	currentY = 0
	
	get_node("../AnimationTimer").wait_time = animationSpeed + 0.1
	get_node("../AnimationTimer").start()
	
	#arrangeWords()
		
func arrangeWords():
	var newScore = 0
	var startX = 50
	var currX = 50
	var currY = 700
	var tweenArray = []
	for word in self.get_children():
		newScore += word.word.length()
		if word.scale.x > 1 or word.scale.y > 1:
			var tween = word.get_node("Tween")
			tween.interpolate_property(word, "scale", word.scale, Vector2(1, 1), animationSpeed, Tween.TRANS_LINEAR, Tween.EASE_IN)
			tweenArray.push_front(tween)
		if (word.word.length() * 50 + currX > 1920):
			currY += 75
			if startX == 50:
				startX = 100
			else:
				startX = 50
			currX = startX
		var tween = word.get_node("Tween")
		tween.interpolate_property(word, "position", Vector2(word.position.x, word.position.y), Vector2(currX, currY), animationSpeed, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tweenArray.push_front(tween)
		currX += (word.word.length() * 50) + 70
		#lastOffset = (word.word.length() * 40) + 60
	get_node('../PlayerScore').updateScore(newScore)
	for element in tweenArray:
		element.start()
		
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_AnimationTimer_timeout():
	arrangeWords()
	pass # Replace with function body.
