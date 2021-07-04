extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var hovering = false

# Called when the node enters the scene tree for the first time.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("MouseClick") and hovering:
		get_tree().change_scene("res://Table.tscn")


func _on_PlayAgain_mouse_entered():
	set("custom_colors/font_color", Color("#f8e1b8"))
	hovering = true


func _on_PlayAgain_mouse_exited():
	set("custom_colors/font_color", Color("#c9a17e"))
	hovering = false
