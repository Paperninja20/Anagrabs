extends LineEdit


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func invalid():
	text = "INVALID WORD"
	editable = false
	selecting_enabled = false
	$Pause.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func unformable():
	text = "CANNOT FORM"
	editable = false
	selecting_enabled = false
	$Pause.start()

func _on_Pause_timeout():
	editable = true
	selecting_enabled = true
	text = ""
	pass # Replace with function body.
