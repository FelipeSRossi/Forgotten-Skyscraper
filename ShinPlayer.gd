extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const G = 600
const JUMP_FORCE = G * 0.38
const SPEED_LIMIT = 20

var velocity = Vector2(0, 0);
var jumping = false

var runspeed = 3
var jumpspeed = 10



var grounded = true
var prev_jump_pressed = false

var move_left = false
var move_right = false
var move_down = false
var up = false

var jump = false
var jumped = false
var desiredY = 0


var falling = true

var animator
var animation = "Idle"


var current_gravity = 1
var collider
var colliderShape


var accel = 0

var sprite_offset = Vector2()

#var damage_rect


func _ready():
	
	
	get_node("sprite/Scarf").emitting = true
	collider = get_node("CollisionShape2D")
	colliderShape = get_node("CollisionShape2D").get_shape()
	sprite_offset = colliderShape.get_extents()
	sprite_offset.y += 3
	print (sprite_offset.y)
	animator = get_node("AnimationPlayer")
	set_physics_process(true)
	set_process_input(true)
	

func _physics_process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
	step_player(delta)
	#print(position)
	return
	

func _input(event):
	if not event.is_echo():

		if event.is_action_pressed("move_left"):
			move_left = true
			move_right = false
			get_node("sprite").set_flip_h(true)

		if event.is_action_pressed("move_right"):
			move_right = true
			move_left = false
			get_node("sprite").set_flip_h(false)

		if event.is_action_pressed("move_down"):
			move_down = true

		if event.is_action_pressed("jump"):
			jump = true
			
		if event.is_action_released("move_down"):
			move_down = false

		if event.is_action_released("move_left"):
			move_left = false

		if event.is_action_released("move_right"):
			move_right = false

		if event.is_action_released("jump"):
			jump = false






func closestXTile(desired_direction, desiredX, space_state):
	# -1 = check left side
	# 1 = check right side

	var frontTile = space_state.intersect_ray(Vector2(global_position.x + desired_direction * sprite_offset.x, global_position.y - sprite_offset.y), Vector2(global_position.x + desired_direction * sprite_offset.x + desiredX, global_position.y + sprite_offset.y -1))
	
	if (frontTile != null && frontTile.has("collider")):
		return min(abs(frontTile.position.x -(global_position.x + desired_direction * sprite_offset.x)),abs(desiredX)) * desired_direction # the smallest amount between the distance to the colliding tile and the desired amount of movement
	else:
		return desiredX


func closestYTile(desired_direction, desiredY, space_state):
	
	var topTile = space_state.intersect_ray(Vector2(global_position.x , global_position.y + desired_direction * sprite_offset.y), Vector2(global_position.x , global_position.y +desired_direction * sprite_offset.y + desiredY))
	if (topTile != null && topTile.has("collider")):
		if(desired_direction == -1):
			print("topi coli")
		elif(desired_direction == 1):
			print("boti coli")
			grounded = true
		return 0
	else:
		print ("nopi coli")
		return desiredY

func step_horizontal(space_state):
	
	if (move_left):
		velocity.x = closestXTile(-1, -runspeed, space_state)

	elif (move_right):
		velocity.x = closestXTile(1, runspeed, space_state)
		
	else:
		velocity.x = 0
	
	return  velocity.x




func step_vertical(space_state):
	
	
	if(falling):
		velocity.y =+ 1
	
		
	if(jump):
		if(grounded):
			velocity.y =- jumpspeed * current_gravity
			grounded = false
			falling = true
	
	
	if(velocity.y >= 0):
		velocity.y = closestYTile(1, velocity.y, space_state)
		print("fallingboyz")
	elif(velocity.y < 0):
		velocity.y = closestYTile(-1, velocity.y, space_state)
		print("risingtide")
	
	
	return velocity.y
		

func step_player(delta):
	
	var space = get_world_2d().get_space()
	var space_state = Physics2DServer.space_get_direct_state(space)
	
	# step horizontal motion first
	velocity.x = step_horizontal(space_state)
	velocity.y = step_vertical(space_state)
	print(velocity.x)
	print(velocity.y)
	
	if grounded:
		if abs(velocity.x) > 0:
			animation = "Run"
		else:
			animation = "Idle"
	else:
		animation = "Jump"
	
	if animator.get_current_animation() != animation:
		animator.play(animation)
	
	translate(velocity)
	print(grounded)
	return



