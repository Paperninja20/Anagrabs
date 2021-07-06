extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tileCount = 0
var left = true

# Called when the node enters the scene tree for the first time.
func _ready():
	text = str(tileCount)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func updateScore(number):
	tileCount = number
	text = str(tileCount)
	#if left:
	#	rect_position.x -= 51 * (str(tileCount).length() - 1)
