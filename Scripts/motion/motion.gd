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
		host.get_node("Kick").scale.x = input_direction
		host.get_node("Hurtbox").scale.x = input_direction
		host.get_node("Parry").scale.x = input_direction
		host.get_node("sprite/Scarf").gravity = Vector2(-input_direction*60,5)

	return
	
