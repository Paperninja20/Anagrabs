extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var textTweenOut = Tween.new()
var textTweenIn = Tween.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	
	textTweenOut.interpolate_property(self, "rect_position", Vector2(265, 780), Vector2(265, 1080), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	add_child(textTweenOut)
	
	textTweenIn.interpolate_property(self, "rect_position", Vector2(1920 + rect_size.x, 780), Vector2(265, 780), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	add_child(textTweenIn)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func moveInOut():
	textTweenOut.interpolate_property(self, "rect_position", Vector2(265, 780), Vector2(265, 1080), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	textTweenIn.interpolate_property(self, "rect_position", Vector2(1920 + rect_size.x, 780), Vector2(265, 780), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	textTweenOut.start()
	yield(textTweenOut, "tween_completed")
	textTweenIn.start()
