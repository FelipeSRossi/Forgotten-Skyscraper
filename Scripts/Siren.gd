extends StaticBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var sprite = $Sprite
var health = 3
var flicker = false
var on = false
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Security")


func _process(delta):
	if(on):
		get_node("AnimationPlayer").play("On")
	else:
		get_node("AnimationPlayer").play("Off")
		health = 3
	
	if(flicker):
		sprite.modulate = Color(10,10,10,10)
		flicker = false
	else:
		sprite.modulate = Color(1,1,1,1)
		
	
	if(health <= 0):
		get_parent().get_parent().get_parent().alarm_state = 0
		get_tree().call_group("Security", "SHUTDOWN")
		on = false
		
func ALARM():
	on = true
	
func SHUTDOWN():
	on = false
	get_parent().get_parent().get_parent().alarm_state = 0
	
func hit_by_bullet():
	health = health - 1
	flicker = true
	
func hit_by_sword():
	health = health - 3
	flicker = true
	
