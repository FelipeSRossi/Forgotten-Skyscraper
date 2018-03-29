extends KinematicBody2D

# This demo shows how to build a kinematic controller.

const SHOOT_TIME_SHOW_WEAPON = 0.2
const G = 450
const JUMP_FORCE = 200
const BULLET_VELOCITY = 300

var velocity = Vector2(0, 0);
var jumping = false
var shoot_time = 99999
var prev_jump_pressed = false

var move_left = false
var move_right = false
var move_down = false
var up = false
var bounce = false

var bounced = false

var bounce_timer = 30

var crouch = false
var jump = false
var jumped = false
var last_jump = false
var spinning = false
var last_shoot = false
var shoot = false
var slide = false
var sliding = false
var slide_timer = 1.5
var last_slide = false

var wall_grab = false
var walled
var grounded
var divekick = false

var animator
var animation = "Idle"
var lastshot = 50
var to_ignore = null;

onready var sprite = $sprite

func _input(event):
	if not event.is_echo():

		if event.is_action_pressed("move_left"):
			move_left = true
			move_right = false
			sprite.scale.x = -1

		if event.is_action_pressed("move_right"):
			move_right = true
			move_left = false
			sprite.scale.x = 1

		if event.is_action_pressed("move_down"):
			move_down = true

		if event.is_action_pressed("jump"):
			jump = true
		
		if event.is_action_pressed("shoot"):
			shoot = true

		if event.is_action_pressed("slide"):
			slide = true

		if event.is_action_released("move_down"):
			move_down = false

		if event.is_action_released("move_left"):
			move_left = false

		if event.is_action_released("move_right"):
			move_right = false

		if event.is_action_released("jump"):
			jump = false

		if event.is_action_released("shoot"):
			shoot = false

		if event.is_action_released("slide"):
			slide = false


func _physics_process(delta):
	
	shoot_time += delta
	
	self.move_and_slide(velocity, Vector2(0, -1), 0, 2);
	grounded = self.is_on_floor()
	walled = self.is_on_wall()
	wall_grab = false
	
	if grounded:
		bounced = false
		spinning = false
		divekick = false
		if(move_down):
			crouch = true
#			to_ignore = move_and_collide(Vector2(0, 1))
#			to_ignore = to_ignore.collider
#			if to_ignore.get_name().match("ground*"):
#				add_collision_exception_with(to_ignore)
		else:
			crouch = false
		
		
		
		if jumped:
			jumped = false
		velocity.y = 1

		if to_ignore:
			remove_collision_exception_with(to_ignore)
			to_ignore = null
	
	#can only grab wall at the top of the jump. Thanks Inticreates
	elif(((walled and move_left) or (walled and move_right) )and not spinning and (velocity.y > 0)):
				wall_grab = true
				velocity.y = G*delta*8
	else:
		velocity.y = min(G, velocity.y+ G * delta)
	
	
	if(walled and spinning and !bounced and !divekick):
		velocity.x = -sprite.scale.x*300
		velocity.y = -300
		bounce = true
		bounced = true
		bounce_timer = 0
			
			
	if(bounce_timer >= 40 or grounded):
		bounce = false
	
	if(!bounce):		
		if move_right and !crouch:
			velocity.x += 100
		elif move_left and !crouch:
			velocity.x += -100
		else:
			velocity.x = 0

	if(velocity.x >= 100):
		velocity.x = 100	
	if(velocity.x <= -100):
		velocity.x = -100


	if(slide and grounded and not sliding and abs(velocity.x) > 0):
			sliding = true
			
	if(sliding and slide_timer > 0):
		slide_timer = slide_timer - delta*3.5
		velocity.x = velocity.x*2.5
		
	else:
		sliding = false
		
	if((slide == false)):
		sliding = false
		if(slide_timer <=0):
			slide_timer = 1
			
	if(slide == false and last_slide == true):
		slide_timer = 1 




	if (jump and grounded) :
		jumped = true
		crouch = false

		velocity.y = min(G, velocity.y - JUMP_FORCE)
	
	#Allows for more precise jumping	
	if((jump == false) and velocity.y < 0):
		velocity.y = velocity.y / 2
			
	if(is_on_ceiling()):
		if(velocity.y < 0):
			velocity.y = 0
			
	if(wall_grab and jump and !last_jump):
		velocity.x = velocity.x - sprite.scale.x*400		
		velocity.y = min(G, velocity.y - JUMP_FORCE)
		
	if (jumped and sliding):
			spinning = true
		# Shooting
	if (shoot and !last_shoot and lastshot > 8 and !crouch and !sliding and !spinning and !wall_grab):
		lastshot = 0
		var bullet = preload("bullet.tscn").instance()
		bullet.position = $sprite/bullet_shoot.global_position #use node for shoot position
		bullet.linear_velocity = Vector2(sprite.scale.x * BULLET_VELOCITY, 0)
		bullet.add_collision_exception_with(self) # don't want player to collide with bullet
		get_parent().add_child(bullet) #don't want bullet to move with me, so add it as child of parent
		shoot_time = 0
		
	if(spinning and shoot):
		divekick = true
	if grounded:
		if(crouch):
			animation = "Crouch"
		elif(sliding and velocity.x !=0):
			animation = "Slide"
		elif abs(velocity.x) > 0:
			if shoot_time < SHOOT_TIME_SHOW_WEAPON:
				animation = "Run Shoot"
			else:
				animation = "Run"
		else:
			if shoot_time < SHOOT_TIME_SHOW_WEAPON:
				animation = "Shoot"
			else:
				animation = "Idle"
	else:
		if(wall_grab):
			animation = "Grab Wall"
			
		elif shoot_time < SHOOT_TIME_SHOW_WEAPON:
			animation = "Jump Shoot"
		elif(spinning):
			if(divekick):
				animation = "DiveKick"
			else:
				animation = "Spin"
		else:
			animation = "Jump"
			



	if animator.get_current_animation() != animation:
		animator.play(animation)
		print(grounded)
	
	last_jump = jump
	last_slide = slide
	lastshot += 1
	bounce_timer +=1
	last_shoot = shoot
	if(lastshot > 50):
		lastshot = 50
	if(bounce_timer > 40):
		bounce_timer = 40
func _ready():
	
	get_node("sprite/Scarf").emitting = true
	animator = self.get_node("AnimationPlayer")
	set_physics_process(true)
	set_process_input(true)

