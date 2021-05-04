extends Area2D


# Declare member variables here. Examples:
# var a = 2
onready var player_vars = get_node("/root/GlobalVar")
var number 
# Called when the node enters the scene tree for the first time.
func _ready():
	number = int(name.lstrip("Checkpoint"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(player_vars.checkpoint > number):
		monitoring = false
	else:
		monitoring = true
