extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var hovering = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("MouseClick") and hovering:
		if Global.difficulty == 3:
			Global.difficulty = 1
		else:
			Global.difficulty += 1


func _on_DifficultySelection_mouse_entered():
	set("custom_colors/font_color", Color("#f8e1b8"))
	hovering = true


func _on_DifficultySelection_mouse_exited():
	set("custom_colors/font_color", Color("#c9a17e"))
	hovering = false
