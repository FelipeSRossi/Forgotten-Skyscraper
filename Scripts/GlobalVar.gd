extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var lives = 3
var checkpoint = 0
var cutscene = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func reset():
	var lives = 3
	var checkpoint = 0
	var cutscene = false
	get_tree().change_scene("res://TitleScreen.tscn")
