extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var hovering = false

# Called when the node enters the scene tree for the first time.
func _input(event):
	if event is InputEventMouseButton and hovering:
		if event.is_pressed():
			get_tree().call_group("MenuGroup", "hide")
			get_parent().get_node("PlayOptions").visible = true
#			get_parent().get_node("PlayOptions").get_node("Singleplayer").visible = true
#			get_parent().get_node("PlayOptions").get_node("Multiplayer").visible = true
			
			hide()
			hovering = false
			set("custom_colors/font_color", Color("#c9a17e"))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Play_mouse_entered():	
	set("custom_colors/font_color", Color("#f8e1b8"))
	hovering = true

func _on_Play_mouse_exited():
	set("custom_colors/font_color", Color("#c9a17e"))
	hovering = false
	
func hide():
	visible = false
