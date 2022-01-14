extends LineEdit


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_NameField_text_changed(new_text):
	Server.playerNick = new_text
	print(Server.playerNick)
	pass # Replace with function body.
