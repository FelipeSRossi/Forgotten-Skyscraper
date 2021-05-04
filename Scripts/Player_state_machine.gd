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
extends KinematicBody2D

signal state_changed

"""
This example keeps a history of some states so e.g. after taking a hit,
the character can return to the previous state. The states_stack is 
an Array, and we use Array.push_front() and Array.pop_front() to add and
remove states from the history.
"""
var states_stack = []
var current_state = null
onready var sprite = $sprite
onready var Hitbox = $Hitbox
onready var Hurtbox = $Hurtbox
onready var player_vars = get_node("/root/GlobalVar")

var JustHit


var another_treadmill = false
var on_treadmill = false
var flicker = false
var damage = false
var melee = false
var shoot = false
var holding = false
var bigshoot = false
var last_shoot = false
var lastshot = 50
var shoot_timer = 500
var health = 20
const BULLET_VELOCITY = 500
var charge = 0
onready var stage_start = get_parent().get_node("StageStart")

onready var states_map = {
	'move': $States/Move,
	'death': $States/Death,
	'slide': $States/Slide,
	'roll': $States/Roll,
	'roll stagger': $States/RollStagger,
	'divekick': $States/DiveKick,
	'cutscene': $States/Cutscene,
	'idle': $States/Idle,
	'jump': $States/Jump,
	'fall': $States/Fall,
	'wall grab': $States/WallGrab,
	'wall jump': $States/WallJump,
	'wall slash': $States/WallSlash,
	'stagger': $States/Stagger,
	'slash': $States/Slash,
	'slash2': $States/Slash2,
	'slash3': $States/Slash3,
	'air slash': $States/AirSlash,
	'move slash': $States/MoveSlash,
	'slide slash': $States/SlideSlash,
	'parry': $States/Parry,
	'air parry': $States/AirParry,
}

func _ready():
	get_node('Parry').monitoring = false
	states_stack.push_front($States/Move)
	current_state = states_stack[0]
	_change_state('move')

# The state machine delegates process and input callbacks to the current state
# The state object, e.g. Move, then handles input, calculates velocity 
# and moves what I called its "host", the Player node (KinematicBody2D) in this case.
func _physics_process(delta):
	
	
	if(position.x < stage_start.position.x):
		position.x = stage_start.position.x
	
	if(holding):
		charge = charge + 1
	else:
		charge = 0
		
	if(charge >100):
		charge = 100

	if(health > 20):
		health = 20
	if(health <= 0):
		_change_state('death')
	
	if(charge == 30):
		JustHit = preload("res://JustHit.tscn").instance()
		add_child(JustHit)
		JustHit.get_node("AnimatedSprite").play("default")	
		
	lastshot += 1

	last_shoot = shoot
	if(lastshot > 50):
		lastshot = 50
	var state_name = current_state.update(self, delta)
	if state_name:
		_change_state(state_name)
	
	if(get_node('StaggerTimer').time_left > 0.1):
		if(flicker == true):
			get_node('sprite').modulate = Color(8,8,8,0.4)
			flicker = false
		else:
			flicker = true
			get_node('sprite').modulate = Color(1,1,1,1)
	else:
		get_node('sprite').modulate = Color(1,1,1,1)
	
	if(get_node('StaggerTimer').is_stopped()):
		get_node('Hurtbox').set_monitoring(true)
	
	if(on_treadmill):
		move_and_slide_with_snap(Vector2(60,0),  Vector2(0,5),Vector2(0,-1), 0, 4)
	
	
	
func _input(event):
	"""
	If you make a shooter game, you may want the player to be able to
	fire bullets anytime.
	If that's the case you don't want to use the states. They'll add micro
	freezes in the gameplay and/or make your code more complex
	Firing is the weapon's responsibility (BulletSpawn here) so the weapon should handle it
	"""
	#if event.is_action_pressed('fire'):
	#	$BulletSpawn.fire(look_direction)
	#	return
	shoot = event.is_action_pressed('shoot')
	
	if(shoot):
		holding = true
	
		
	if (shoot and !(current_state.name in ['Cutscene','Roll','Slash','Slash2','Slash3', 'WallSlash','AirSlash','Parry', 'AirParry','MoveSlash','SlideSlash','DiveKick']) and !last_shoot and lastshot > 8):
		lastshot = 0
		var bullet = preload("res://bullet.tscn").instance()
		bullet.scale.x = sprite.scale.x
		bullet.position = $sprite/bullet_shoot.global_position #use node for shoot position
		bullet.linear_velocity = Vector2((sprite.scale.x * BULLET_VELOCITY ), 0) 
		bullet.add_collision_exception_with(self) # don't want player to collide with bullet
		get_parent().add_child(bullet) #don't want bullet to move with me, so add it as child of parent
		shoot_timer = 0
		if(get_node('AnimationPlayer2').current_animation == 'shuriken 1'):
			get_node('AnimationPlayer3').play('shuriken 2')	
		elif(get_node('AnimationPlayer3').current_animation == 'shuriken 2'):
			get_node('AnimationPlayer2').play('shuriken 1')
		else:
			get_node('AnimationPlayer2').play('shuriken 1')
	
	if(event.is_action_released('shoot') and charge >= 90  and !(current_state.name in ['Cutscene','Roll','Slash','Slash2','Slash3', 'WallSlash','AirSlash','Parry', 'AirParry','MoveSlash','SlideSlash','DiveKick'])):
		charge = 0
		lastshot = 0
		var Bigbullet = preload("res://Bigbullet.tscn").instance()
		Bigbullet.scale.x = sprite.scale.x
		Bigbullet.position = $sprite/bullet_shoot.global_position #use node for shoot position
		Bigbullet.linear_velocity = Vector2((sprite.scale.x * BULLET_VELOCITY ), 0) 
		Bigbullet.add_collision_exception_with(self) # don't want player to collide with bullet
		get_parent().add_child(Bigbullet) #don't want bullet to move with me, so add it as child of parent
		shoot_timer = 0
		if(get_node('AnimationPlayer2').current_animation == 'shuriken 1'):
			get_node('AnimationPlayer3').play('shuriken 2')	
		elif(get_node('AnimationPlayer3').current_animation == 'shuriken 2'):
			get_node('AnimationPlayer2').play('shuriken 1')
		else:
			get_node('AnimationPlayer2').play('shuriken 1')	
	elif(event.is_action_released('shoot') and charge <= 90  and charge >= 25 and !(current_state.name in ['Cutscene','Roll','Slash', 'WallSlash','AirSlash','Parry', 'AirParry','MoveSlash','DiveKick'])):
		charge = 0
		lastshot = 0
		
		var Medbullet = preload("res://Medbullet.tscn").instance()
			
		if(JustHit.get_node("AnimatedSprite").frame == 3 or JustHit.get_node("AnimatedSprite").frame == 2):
			var perfectHit = preload("res://JustHitPerfect.tscn").instance()
			add_child(perfectHit)
			perfectHit.get_node("AnimatedSprite").play("default")
			Medbullet = preload("res://Kunai.tscn").instance()
			
		Medbullet.scale.x = sprite.scale.x
		Medbullet.position = $sprite/bullet_shoot.global_position #use node for shoot position
		Medbullet.linear_velocity = Vector2((sprite.scale.x * BULLET_VELOCITY ), 0) 
		Medbullet.add_collision_exception_with(self) # don't want player to collide with bullet
		get_parent().add_child(Medbullet) #don't want bullet to move with me, so add it as child of parent
		shoot_timer = 0
		if(get_node('AnimationPlayer2').current_animation == 'shuriken 1'):
			get_node('AnimationPlayer3').play('shuriken 2')	
		elif(get_node('AnimationPlayer3').current_animation == 'shuriken 2'):
			get_node('AnimationPlayer2').play('shuriken 1')
		else:
			get_node('AnimationPlayer2').play('shuriken 1')	
	elif(event.is_action_released('shoot') and charge >= 90  and (current_state.name == 'Roll')):
		charge = 0
		_change_state('divekick')
	if(event.is_action_released('shoot')):
		holding = false
		
	var state_name = current_state.handle_input(self, event)
	if state_name:
		_change_state(state_name)



 
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
	elif state_name in ['stagger', 'jump', 'fall','air slash','air parry']:
		states_stack.push_front(states_map[state_name])
	else:
		var new_state = states_map[state_name]
		states_stack[0] = new_state

	if state_name == 'jump':
		$States/Jump.initialize( current_state.velocity)
	if state_name == 'slide slash':
		$States/Roll.initialize( current_state.velocity)

	if state_name == 'roll':
		$States/Roll.initialize( current_state.velocity)
	if state_name == 'rollstagger':
		$States/Roll.initialize( current_state.velocity)
	if state_name == 'fall':
		$States/Fall.initialize( current_state.velocity)
	if state_name == 'air slash':
		$States/AirSlash.initialize( current_state.velocity)
	if state_name == 'air parry':
		$States/AirParry.initialize( current_state.velocity)
	if state_name == 'divekick':
		$States/DiveKick.initialize( current_state.velocity)
	if state_name == 'wall grab':
		$States/WallGrab.initialize(current_state.get_input_direction(), current_state.enter_velocity)
	if state_name == 'wall slash':
		$States/WallSlash.initialize(current_state.get_input_direction(), current_state.enter_velocity)

	current_state = states_stack[0]
	if state_name != 'previous':
		# We don't want to reinitialize the state if we're going back to the previous state
		current_state.enter(self)
	emit_signal('state_changed', states_stack)


func hit_by_enemy_bullet():
	if(get_node('StaggerTimer').is_stopped() and current_state.name != 'Cutscene'):
		_change_state('stagger')

func _on_Hurtbox_area_entered(area):
	if("Scout" in area.name and get_node('StaggerTimer').is_stopped() and  current_state.name != 'Cutscene'):
		health -= 5
		_change_state('stagger')
	elif("Spikes" in area.name and get_node('StaggerTimer').is_stopped() and  current_state.name != 'Cutscene'):
		health = 0
		#_change_state('stagger')
		
	if("Treadmill" in area.name and on_treadmill == true):
		another_treadmill = true	
	elif("Treadmill" in area.name and on_treadmill == false):
		on_treadmill = true
	
	if("Crusher" in area.name):
		health = 0

		

func _on_Hurtbox_area_exited(area):
	if("Treadmill" in area.name):
		if(!another_treadmill):
			on_treadmill = false
		else :
			another_treadmill = false
			
	
func _on_Hitbox_area_entered(area):
	pass
	
func _on_Hitbox_area_exited(area):
	pass



func _on_Hitbox_body_entered(body):
	if body.has_method("hit_by_sword"):
		body.call("hit_by_sword")



func _on_Timer_timeout():
	pass 

func _on_Kick_body_entered(body):
	if body.has_method("hit_by_kick"):
		body.call("hit_by_kick")



func enter_cutscene():
	_change_state('cutscene')
		
func exit_cutscene():
	_change_state('idle')

