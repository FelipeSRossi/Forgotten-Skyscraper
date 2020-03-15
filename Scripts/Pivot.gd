extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var inarea = false
var incounter = 0
var lock = false
var rotate_left = true
signal alert
onready var color = get_node("Patrol /CollisionShape2D/Polygon2D").color
onready var playerpos = get_parent().get_parent().get_parent().get_node("player/CollisionShape2D").global_position
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(!rotate_left and rotation_degrees >= (90)):
			rotate_left = true
	elif(rotation_degrees <= (-90)):
			rotate_left = false
	
	if(!inarea):
		incounter = incounter +1
	else:
		incounter = 0
	
	if(incounter == 0):
		lock = true
	elif(incounter >=3):
		lock = false
	
	if(lock):
		get_node("Patrol /CollisionShape2D/Polygon2D").color =  Color("#85ff006d")
		
	else:
		get_node("Patrol /CollisionShape2D/Polygon2D").color = color
		if(rotate_left):
			rotation_degrees = rotation_degrees - 0.5
		else:
			rotation_degrees = rotation_degrees + 0.5
			
			
	playerpos = get_parent().get_parent().get_parent().get_node("player/CollisionShape2D").global_position

func _on_Patrol__area_entered(area):
	if((area).name == "Hurtbox"):
		inarea = true


func _on_Patrol__area_exited(area):
	if((area).name == "Hurtbox"):
		inarea = false

