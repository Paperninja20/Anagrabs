extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var hovering = false

# Called when the node enters the scene tree for the first time.
func _input(event):
	if event is InputEventMouseButton and hovering:
		if event.is_pressed():
			Server.JoinLobby(Server.DEFAULT_IP)
			get_tree().change_scene("res://MultiplayerPlayspace.tscn")
			hovering = false
			set("custom_colors/font_color", Color("#c9a17e"))


func _on_JoinLabel_mouse_entered():
	set("custom_colors/font_color", Color("#f8e1b8"))
	hovering = true


func _on_JoinLabel_mouse_exited():
	set("custom_colors/font_color", Color("#c9a17e"))
	hovering = false
