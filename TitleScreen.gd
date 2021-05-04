extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var current = 0
var activate = false
# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Start").grab_focus()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if(current == 0):
		get_node("Start").text = "Game Start"
	elif(current == 1):
		get_node("Start").text = "Options"
	elif(current == 2):
		get_node("Start").text = "Quit"

	
	if(activate):
		if(current == 0):
			get_tree().change_scene("res://3Dmain.tscn")
		elif(current == 1):
			get_tree().change_scene("res://Options.tscn")
		elif(current == 2):
			get_tree().quit()
	
	pass


func _input(event):
	if(event.is_action_pressed("ui_left") or event.is_action_pressed("move_left") ): 
		get_node("KeyAnimator").play("left_bop")
		current = current - 1
	elif(event.is_action_pressed("ui_right") or event.is_action_pressed("move_right")):
		get_node("KeyAnimator").play("right_bop")
		current = current + 1
		
	if(current < 0):
		current = 2
	elif(current > 2):
		current = 0
		
	if(event.is_action_pressed("ui_accept")):
		activate = true

func _on_Start_pressed():
	activate = true
