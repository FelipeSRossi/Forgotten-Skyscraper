extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func hit_by_bullet():
	get_parent().hit_by_bullet()
	
func hit_by_sword():
	get_parent().hit_by_sword()

func hit_by_kick():
	get_parent().hit_by_kick()
	
