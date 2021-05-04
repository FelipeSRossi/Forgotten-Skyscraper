extends CPUParticles2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(float) var MAX_RUN_SPEED = 150

var Animster
var slide 
var roll
var divekick
var Hayah
var current_anim
var jumpetto
var Jump
# Called when the node enters the scene tree for the first time.
func _ready():
	Animster = get_parent().get_parent().get_node("AnimationPlayer")
	jumpetto = get_parent().get_parent().current_state
	slide = load('res://Assets/slide.png')
	roll = load('res://Assets/roll.png')
	divekick = load('res://Assets/divekick.png')
	Hayah = load('res://Assets/Hayah.png')
	Jump = load('res://Assets/Jump.png')
	
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
	elif(Animster.current_animation == "Jump-rise" or Animster.current_animation == "Jump-start"or Animster.current_animation == "Air Slash" or Animster.current_animation == "Jump-fall") and(abs(get_parent().get_parent().current_state.velocity.x) > MAX_RUN_SPEED):
		set_texture(Jump)
		emitting = true
	else:
		emitting = false
	pass


func _on_AnimationPlayer_animation_finished(anim_name):
		current_anim = anim_name
