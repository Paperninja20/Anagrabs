extends Label


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Quit_mouse_entered():
	set("custom_colors/font_color", Color("#f8e1b8"))


func _on_Quit_mouse_exited():
	set("custom_colors/font_color", Color("#c9a17e"))
