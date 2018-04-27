extends KinematicBody2D

# This demo shows how to build a kinematic controller.

const SHOOT_TIME_SHOW_WEAPON = 0.2
const G = 450
const JUMP_FORCE = 200
const BULLET_VELOCITY = 300

var velocity = Vector2(0, 0);
var jumping = false
var shoot_timer = 99999
var prev_jump_pressed = false

var damage = false
var damage_timer = 0.5
var move_left = false
var move_right = false
var move_down = false
var up = false

var HP = 54

var can_move = true
var can_jump = true
var air_slash = false
var slash = false
var slashing = false
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
var charge_timer = 0

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
	
	shoot_timer += delta
	
	damage_timer += delta
	
	get_parent().get_node("HUD").get_node("GUI").get_node("HealthBar").value = HP
	
	
	if(damage_timer <= 0.5):
		self.modulate = Color(1,1,1,0.5)
		set_collision_mask_bit( 1,0 )
	else:
		self.modulate = Color(1,1,1,1)
		set_collision_mask_bit( 1,1 )
	
	if(charge_timer >=1 and grounded and !shoot):
		slash = true
	elif(charge_timer >=1 and !grounded and !shoot and !spinning and !divekick and !wall_grab):
		air_slash = true
	
	
	if(damage):
		velocity = Vector2(-(sprite.scale.x)*50, 0)
		damage_timer = 0
	
	if(shoot):
		charge_timer += delta
	else:
		charge_timer = 0
		
	get_node("sprite/Scarf").self_modulate = Color(0.02,0.018 +charge_timer, 0.59,1)
	
	self.move_and_slide(velocity, Vector2(0, -1), 0, 2);
	
	if(get_slide_count()):
		for i in range(get_slide_count()):
			var collision = get_slide_collision(i)
			if("scout" in collision.collider.name and damage_timer >= 0.5):
				damage = true
				slash = false
				divekick = false
				air_slash = false
				spinning = false
				crouch = false
				wall_grab = false
				HP -= 2

	
	grounded = self.is_on_floor()
	walled = self.is_on_wall()
	wall_grab = false
	
	if grounded:
		spinning = false
		divekick = false
		air_slash = false
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
	elif(((walled and move_left) or (walled and move_right) ) and (velocity.y > 0) and !divekick and !damage):
				spinning = false
				wall_grab = true
				velocity.y = G*delta*8
	else:
		velocity.y = min(G, velocity.y+ G * delta)
		slash = false
	
	

	
	if move_right and !crouch and !damage:
		velocity.x += 100
	elif move_left and !crouch and !damage:
		velocity.x += -100
	else:
		velocity.x = 0

	if(velocity.x >= 100):
		velocity.x = 100	
	if(velocity.x <= -100):
		velocity.x = -100


	if(slide and grounded and not sliding and abs(velocity.x) > 0 and !slash and !damage):
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




	if (jump and grounded and !damage) :
		jumped = true
		crouch = false

		velocity.y = min(G, velocity.y - JUMP_FORCE)
	
	#Allows for more precise jumping	
	if((jump == false) and velocity.y < 0):
		velocity.y = velocity.y / 2
			
	if(is_on_ceiling()):
		if(velocity.y < 0):
			velocity.y = 0
			
	if(wall_grab and jump and !last_jump and !damage):
		velocity.x = velocity.x - sprite.scale.x*400		
		velocity.y = min(G, velocity.y - JUMP_FORCE)
		
	if (jumped and sliding and !damage):
			spinning = true
		# Shooting
	if (shoot and !last_shoot and lastshot > 8 and !crouch and !sliding and !spinning and !wall_grab and !slash and !air_slash and !damage):
		lastshot = 0
		var bullet = preload("bullet.tscn").instance()
		bullet.position = $sprite/bullet_shoot.global_position #use node for shoot position
		bullet.linear_velocity = Vector2(sprite.scale.x * BULLET_VELOCITY, 0)
		bullet.add_collision_exception_with(self) # don't want player to collide with bullet
		get_parent().add_child(bullet) #don't want bullet to move with me, so add it as child of parent
		shoot_timer = 0
		
	
	if(spinning and shoot and !last_shoot and lastshot > 8 and !damage):
		divekick = true
		
	if(damage):
		animation = "Damage"
		
	elif grounded:
		if(slash):
			animation = "Slash"

		elif(crouch):
			animation = "Crouch"
		elif(sliding and velocity.x !=0):
			animation = "Slide"
		elif abs(velocity.x) > 0:
			if shoot_timer < SHOOT_TIME_SHOW_WEAPON:
				animation = "Run Shoot"
			else:
				animation = "Run"
		else:
			if shoot_timer < SHOOT_TIME_SHOW_WEAPON:
				animation = "Shoot"
			else:
				animation = "Idle"
	else:
		if(air_slash):
			animation = "Air Slash"
		elif(wall_grab):
			animation = "Grab Wall"
			
		elif shoot_timer < SHOOT_TIME_SHOW_WEAPON:
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
		
	
	last_jump = jump
	last_slide = slide
	lastshot += 1

	last_shoot = shoot
	if(lastshot > 50):
		lastshot = 50


func slash():
	slashing = true
	
func slash_end():
	air_slash = false
	slash = false
	

func _ready():
	
	get_node("sprite/Scarf").emitting = true
	animator = self.get_node("AnimationPlayer")
	set_physics_process(true)
	set_process_input(true)

func damage_end():
	damage = false