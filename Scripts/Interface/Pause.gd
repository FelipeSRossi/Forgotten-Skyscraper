extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var cutscene

# Called when the node enters the scene tree for the first time.
func _ready():
	cutscene = get_parent().get_parent().get_node("CutsceneOverlay/Cutscene")



func _input(event):
	if(event.is_action_pressed("pause") and !cutscene.visible): 
		var new_pause = !get_tree().paused
		get_tree().paused = new_pause
		visible = new_pause

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):

