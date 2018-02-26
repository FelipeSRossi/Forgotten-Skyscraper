extends KinematicBody2D

# This demo shows how to build a kinematic controller.

const SHOOT_TIME_SHOW_WEAPON = 0.2
const G = 600
const JUMP_FORCE = G * 0.38
const BULLET_VELOCITY = 300

var velocity = Vector2(0, 0);
var on_air_time = 100
var jumping = false
var shoot_time = 99999
var prev_jump_pressed = false

var move_left = false
var move_right = false
var move_down = false
var up = false

var jump = false
var jumped = false

var shoot = false
var slide = false

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
	var grounded = self.is_on_floor()
	

		
	
	
	if grounded:
		
		if jumped:
			jumped = false
		velocity.y = 1

		if to_ignore:
			remove_collision_exception_with(to_ignore)
			to_ignore = null

	elif velocity.y < G:
		velocity.y += G * delta

	else:
		velocity.y = G



	if move_right:
		velocity.x = 100
	elif move_left:
		velocity.x = -100
	else:
		velocity.x = 0


	if jump and grounded:
		
		jump = false
		jumped = true

		if move_down:
			to_ignore = move_and_collide(Vector2(0, 1))
			to_ignore = to_ignore.collider
			if to_ignore.get_name().match("ground*"):
				add_collision_exception_with(to_ignore)

		else:
			velocity.y -= JUMP_FORCE
		
		
		
		if move_left:
			velocity.x = -75
		elif move_right:
			velocity.x = 75
			
	if(is_on_ceiling()):
		if(velocity.y < 0):
			velocity.y = 0
			
			
		# Shooting
	if (shoot && lastshot > 10):
		lastshot = 0
		var bullet = preload("bullet.tscn").instance()
		bullet.position = $sprite/bullet_shoot.global_position #use node for shoot position
		bullet.linear_velocity = Vector2(sprite.scale.x * BULLET_VELOCITY, 0)
		bullet.add_collision_exception_with(self) # don't want player to collide with bullet
		get_parent().add_child(bullet) #don't want bullet to move with me, so add it as child of parent
		shoot_time = 0

	if grounded:
		if abs(velocity.x) > 0:
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
		if shoot_time < SHOOT_TIME_SHOW_WEAPON:
			animation = "Jump Shoot"
		else:
			animation = "Jump"
			



	if animator.get_current_animation() != animation:
		animator.play(animation)
		print(grounded)
	
	lastshot += 1
	if(lastshot > 50):
		lastshot = 50
	
func _ready():
	
	get_node("sprite/Scarf").emitting = true
	animator = self.get_node("AnimationPlayer")
	set_physics_process(true)
	set_process_input(true)
