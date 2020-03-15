extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Boss
var enabled = true
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_Trigger_area_entered(area):
	if(enabled):
		if(area.name == "Hurtbox"):
			var Boss = preload("res://FSMSecurityBOSS.tscn").instance()
			Boss.global_position = get_node("Spawn").global_position
			enabled = false
