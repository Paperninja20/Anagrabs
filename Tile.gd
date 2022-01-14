extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var tileLetter = 'A'
var mouseHover = false
var dragging = false
var offsetX
var offsetY
var globalPos
var tileID
# Called when the node enters the scene tree for the first time.
func _ready():
	$Letter.text = tileLetter
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	"""var mousePos = get_global_mouse_position()
	if Input.is_action_pressed("MouseClick") && mouseHover:
		position.x = mousePos.x - offsetX
		position.y = mousePos.y - offsetY
	if Input.is_action_just_released("MouseClick") && mouseHover:
		z_index = 0
		"""
		
func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed() && mouseHover:
			z_index = 1
			offsetX = get_global_mouse_position().x - position.x
			offsetY = get_global_mouse_position().y - position.y

func _on_Area2D_mouse_entered():
	if !(Input.is_action_pressed("MouseClick")):
		mouseHover = true


func _on_Area2D_mouse_exited():
	if !(Input.is_action_pressed("MouseClick")):
		mouseHover = false


func _on_Tween_tween_all_completed():
	globalPos = global_position
	pass # Replace with function body.
