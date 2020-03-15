extends CPUParticles2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Animster
var slide 
var roll
var divekick
var Hayah
# Called when the node enters the scene tree for the first time.
func _ready():
	Animster = get_parent().get_parent().get_node("AnimationPlayer")
	slide = load('res://Assets/slide.png')
	roll = load('res://Assets/roll.png')
	divekick = load('res://Assets/divekick.png')
	Hayah = load('res://Assets/Hayah.png')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if( Animster.current_animation =="Slide" ):
		set_texture(slide)
		emitting = true
	elif( Animster.current_animation =="Roll"):
		set_texture(roll)
		emitting = true
	elif( Animster.current_animation == "DiveKick"):
		set_texture(divekick)
		emitting = true
	elif( Animster.current_animation == "Slash 3"):
		set_texture(Hayah)
		emitting = true
	else:
		emitting = false
	pass
