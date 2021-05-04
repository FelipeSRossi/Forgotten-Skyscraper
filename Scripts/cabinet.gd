extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var alarm = false
var oldalarm = false
var activated = false
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Security")

func _process(delta):
	if(alarm and !oldalarm):
		get_node("AnimationPlayer").play("open")
		var SecurityTrooper = preload("res://Level 2/Enemies/FSMSecurityTrooper.tscn").instance()
		SecurityTrooper.position = Vector2(global_position.x, global_position.y+11)
		get_parent().add_child(SecurityTrooper)
	oldalarm = alarm
	
func ALARM():
	alarm = true
	
func SHUTDOWN():
	alarm = false
	get_node("AnimationPlayer").play("close")
