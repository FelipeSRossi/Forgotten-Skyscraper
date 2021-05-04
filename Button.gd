extends Button

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_Button_pressed():
	get_tree().change_scene("res://3Dmain.tscn")


func _input(event):
	if(event.is_action_pressed("pause")): 
		get_tree().change_scene("res://3Dmain.tscn")
