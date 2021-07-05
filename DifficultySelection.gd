extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var hovering = false

# Called when the node enters the scene tree for the first time.
func _ready():
	updateText()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	if event is InputEventMouseButton and hovering:
		if event.is_pressed():
			if Global.difficulty == 3:
				Global.difficulty = 1
			else:
				Global.difficulty += 1
			updateText()
			

func updateText():
	if Global.difficulty == 1:
		text = "EASY"
	elif Global.difficulty == 2:
		text = "MEDIUM"
	else:
		text = "HARD"

func _on_DifficultySelection_mouse_entered():
	set("custom_colors/font_color", Color("#f8e1b8"))
	hovering = true


func _on_DifficultySelection_mouse_exited():
	set("custom_colors/font_color", Color("#c9a17e"))
	hovering = false
