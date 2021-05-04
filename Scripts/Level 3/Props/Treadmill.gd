extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var bodies = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	pass
	for body in bodies :
		body.get_parent().move_and_slide_with_snap(Vector2(-2, 0),  Vector2(0,5),Vector2(0,-1), 0, 4)

func _on_Area2D_body_entered(body):
	if(body.name == 'player'):
		bodies.append(body)


func _on_Area2D_body_exited(body):
	if(body.name == 'player'):
		bodies.erase(body)


func _on_Area2D_area_entered(area):
	if(area.name == 'Hurtbox'):
		bodies.append(area)


func _on_Area2D_area_exited(area):
	if(area.name == 'Hurtbox'):
		bodies.erase(area)
