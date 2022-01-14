extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var currTexture = 1

var tutorialGuyOut = Tween.new()
var tutorialGuyIn = Tween.new()

func toggleSprite():
	if currTexture == 2:
		currTexture = 1
	else:
		currTexture += 1
	var path = "res://Assets/Tutorial" + str(currTexture) + ".png"
	texture = load(path)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	
	tutorialGuyOut.interpolate_property(get_node("../TutorialGuy"), "position", Vector2(1600, 800), Vector2(2200, 800), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	add_child(tutorialGuyOut)
	
	tutorialGuyIn.interpolate_property(get_node("../TutorialGuy"), "position", Vector2(2200, 800), Vector2(1600, 800), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	add_child(tutorialGuyIn)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func moveInOut(toggle):
	tutorialGuyOut.interpolate_property(get_node("../TutorialGuy"), "position", Vector2(1600, 800), Vector2(2200, 800), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tutorialGuyIn.interpolate_property(get_node("../TutorialGuy"), "position", Vector2(2200, 800), Vector2(1600, 800), 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tutorialGuyOut.start()
	yield(tutorialGuyOut, "tween_completed")
	if toggle:
		toggleSprite()
	tutorialGuyIn.start()
	if currTexture == 2:
		$TutorialGuySound.play()
