extends StaticBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var alarm = false
var oldalarm = false
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Security")
	get_node("AnimationPlayer").play("Lower")

func _process(delta):
	if(alarm and !oldalarm):
		get_node("AnimationPlayer").play("Raise")
	oldalarm = alarm
func ALARM():
	alarm = true
	
func SHUTDOWN():
	get_node("AnimationPlayer").play("Lower")
	alarm = false
