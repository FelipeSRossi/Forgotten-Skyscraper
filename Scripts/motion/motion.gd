# Collection of important methods to handle direction and animation
extends '../state.gd'


func handle_input(host, event):
	return

func get_input_direction():
	var input_direction = int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left"))
	return input_direction

func update_siding(host, input_direction):
	if(input_direction):
		host.get_node("sprite").scale.x = input_direction
		host.get_node("Hitbox").scale.x = input_direction
		host.get_node("sprite/Scarf").process_material.gravity = Vector3(-input_direction*60,5,0)
		host.get_node("Hitbox").position.x = input_direction*host.get_node("Hitbox").position.x
	return