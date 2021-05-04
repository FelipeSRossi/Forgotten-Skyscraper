
"""
The point of the State pattern is to separate concerns, to help follow
the single responsibility principle. Each state describes an action or 
behavior.

The state machine is the only entity that's aware of the states. 
That's why this script receives strings from the states: it maps 
these strings to actual state objects: the states (Move, Jump, etc.)
are not aware of their siblings. This way you can change any of 
the states anytime without breaking the game.
"""
extends Node2D

signal state_changed

"""
This example keeps a history of some states so e.g. after taking a hit,
the character can return to the previous state. The states_stack is 
an Array, and we use Array.push_front() and Array.pop_front() to add and
remove states from the history.
"""
var states_stack = []
var current_state = null

var animation_finished = false
var flicker = false
var damage = false
var melee = false
var shoot = false
var last_shoot = false
var lastshot = 50
var shoot_timer = 500
var health = 65
#var health = 20
const BULLET_VELOCITY = 350
const GRAVITY = 100
onready var states_map = {
	'move': $States/Move,
	'flip': $States/Flip,
	'shoot': $States/Shoot,
	'idle': $States/Idle,
}

func _ready():
	states_stack.push_front($States/Idle)
	current_state = states_stack[0]
	_change_state('idle')


# The state machine delegates process and input callbacks to the current state
# The state object, e.g. Move, then handles input, calculates velocity 
# and moves what I called its "host", the Player node (KinematicBody2D) in this case.
func _physics_process(delta):
	

	var state_name = current_state.update(self, delta)
	if state_name:
		_change_state(state_name)
	
	if(flicker):
		modulate = Color(10,10,10,10)
		flicker = false
	else:
		modulate = Color(1,1,1,1)
	
	if(health <= 17):
		get_node("AnimationPlayer").play("Defeat")
		get_parent().get_parent().get_parent().get_node("HUD/Victory/AnimationPlayer").play("Slide-in")
		_change_state('idle')

		
		#get_tree().change_scene("res://DefaultMenu.tscn")
		#queue_free()


 
func _on_animation_finished(anim_name):
	"""
	We want to delegate every method or callback that could trigger 
	a state change to the state objects. The base script state.gd,
	that all states extend, makes sure that all states have the same
	interface, that is to say access to the same base methods, including
	_on_animation_finished. See state.gd
	"""
	var state_name = current_state._on_animation_finished(anim_name)
	if state_name:
		_change_state(state_name)


func _change_state(state_name):
	"""
	We use this method to:
		1. Clean up the current state with its the exit method
		2. Manage the flow and the history of states
		3. Initialize the new state with its enter method
	Note that to go back to the previous state in the states history,
	the state objects return the 'previous' keyword and not a specific
	state name.
	"""
	current_state.exit(self)

	if state_name == 'previous':
		states_stack.pop_front()
	elif state_name in ['shoot', 'move', 'idle', 'flip']:
		states_stack.push_front(states_map[state_name])
	else:
		var new_state = states_map[state_name]
		states_stack[0] = new_state

	current_state = states_stack[0]
	if state_name != 'previous':
		# We don't want to reinitialize the state if we're going back to the previous state
		current_state.enter(self)
	emit_signal('state_changed', states_stack)



func _on_Scout_area_entered(area):
	pass # Replace with function body.



func hit_by_bullet():
	flicker = true
	health = health - 1
	
func hit_by_Medbullet():
	flicker = true
	health = health - 2
	
func hit_by_Bigbullet():
	flicker = true
	health = health - 3

	
func hit_by_sword():
	flicker = true
	get_node("HitStop").start()
	get_tree().paused = true
	health = health - 3
	

func hit_by_kick():
	flicker = true
	health = health - 3
	
func activate():
	_change_state("move")


func _on_AnimationPlayer_animation_finished(anim_name):
		animation_finished = true

func explode(Xposition):
	var explosion = preload("res://explosion.tscn").instance()
	explosion.position = global_position + Xposition
	get_parent().add_child(explosion)


func _on_HitStop_timeout():
	get_tree().paused = false

