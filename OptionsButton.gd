extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tile = preload("res://Tile.tscn")
var hovering = false

func _ready():
	pass # Replace with function body.


func _input(event):
	if event is InputEventMouseButton and hovering:
		if event.is_pressed():
			get_tree().call_group("MenuGroup", "hide")
			get_parent().get_node("OptionsScene").visible = true
			hide()
			hovering = false
			set("custom_colors/font_color", Color("#c9a17e"))

	
func _on_Options_mouse_entered():
	set("custom_colors/font_color", Color("#f8e1b8"))
	hovering = true

func _on_Options_mouse_exited():
	set("custom_colors/font_color", Color("#c9a17e"))
	hovering = false

func hide():
	visible = false

