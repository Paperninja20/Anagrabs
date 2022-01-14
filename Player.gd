extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var wordXIndex = 50
var wordYIndex = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	if position.y > 520:
		wordYIndex = 700
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
