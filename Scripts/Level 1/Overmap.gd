extends TileMap

var faded = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_MetroDetect_body_shape_entered(body_id, body, body_shape, area_shape):
	if(body.name == 'player') and !(faded):
		get_node('FadeoutPlayer').play("Fadeout")
		faded = true


func _on_MetroExit_body_shape_entered(body_id, body, body_shape, area_shape):
	if(body.name == 'player') and (faded):
		get_node('FadeoutPlayer').play("Fadein")
		faded = false
