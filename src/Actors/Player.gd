class_name Player
extends Actor


const FLOOR_DETECT_DISTANCE = 20.0
# How much the player's walking speed is increased when doing a dash
const DASH_MULTIPLIER = 1.75 
# The minimum amount a joystick needs to be moved for an input to be valid
const JOYSTICK_POWER_THRESHOLD = 0.1

export(String) var action_suffix = ""

onready var platform_detector = $PlatformDetector
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var shoot_timer = $ShootAnimation
onready var shoot_cooldown = $ShootCooldown
onready var dash_timer = $DashLength
onready var gun = $Sprite/Gun
onready var dash_spawn = $Sprite/DashSpawn
onready var ghost_spawn = $GhostSpawn

var dash = false
var last_horizontal_direction = 1
#This is our little cheat so that player can hold a direction and jump back easily
var turn_buffer = [false, false, false, false, false, false, false, false, false, false]


func _ready():
	# Static types are necessary here to avoid warnings.
	var camera: Camera2D = $Camera
	if action_suffix == "_p1":
		camera.custom_viewport = $"../.."
	elif action_suffix == "_p2":
		var viewport: Viewport = $"../../../../ViewportContainer2/Viewport"
		viewport.world_2d = ($"../.." as Viewport).world_2d
		camera.custom_viewport = viewport


# Physics process is a built-in loop in Godot.
# If you define _physics_process on a node, Godot will call it every frame.

# We use separate functions to calculate the direction and velocity to make this one easier to read.
# At a glance, you can see that the physics process loop:
# 1. Calculates the move direction.
# 2. Calculates the move velocity.
# 3. Moves the character.
# 4. Updates the sprite direction.
# 5. Shoots bullets.
# 6. Updates the animation.

# Splitting the physics process logic into functions not only makes it
# easier to read, it help to change or improve the code later on:
# - If you need to change a calculation, you can use Go To -> Function
#   (Ctrl Alt F) to quickly jump to the corresponding function.
# - If you split the character into a state machine or more advanced pattern,
#   you can easily move individual functions.
func _physics_process(_delta):	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		$Jump.stop()
		$Jump.play()
		
	var direction = get_direction()

	var is_jump_interrupted = Input.is_action_just_released("jump" + action_suffix) and _velocity.y < 0.0
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)

	var snap_vector = Vector2.DOWN * FLOOR_DETECT_DISTANCE if direction.y == 0.0 else Vector2.ZERO
	var is_on_platform = platform_detector.is_colliding()
	_velocity = move_and_slide_with_snap(
		_velocity, snap_vector, FLOOR_NORMAL, not is_on_platform, 4, 0.9, false
	)

	# When the character’s direction changes, we want to to scale the Sprite accordingly to flip it.
	# This will make Robi face left or right depending on the direction you move.
	if direction.x != 0:
		#We don't want to change direction if midair shooting
		if Input.is_action_pressed("shoot") and not is_on_floor():
			turn_buffer.push_front(true)
			turn_buffer.pop_back()
		else:
			turn_buffer.push_front(false)
			turn_buffer.pop_back()
			
		if not turn_buffer.has(true):
			sprite.scale.x = 1 if direction.x > 0 else -1

	# We use the sprite's scale to store Robi’s look direction which allows us to shoot
	# bullets forward.
	# There are many situations like these where you can reuse existing properties instead of
	# creating new variables.
	var is_shooting = false
	if Input.is_action_pressed("shoot" + action_suffix) and shoot_cooldown.is_stopped():
		is_shooting = gun.shoot(sprite.scale.x)
		shoot_cooldown.start()

	var animation = get_new_animation(is_shooting)
	if animation != sprite.animation and shoot_timer.is_stopped():
		if is_shooting:
			shoot_timer.start()
		sprite.play(animation)
		
	#Check for dash
	var no_left_right = abs(Input.get_action_strength("move_right" + action_suffix) - Input.get_action_strength("move_left" + action_suffix)) < JOYSTICK_POWER_THRESHOLD
	if (dash_timer.is_stopped() or (not Input.is_action_pressed("dash") and no_left_right)) and is_on_floor() :
		dash = false
		dash_timer.stop()
	if Input.is_action_just_pressed("dash") and is_on_floor():
		dash = true
		dash_timer.start()
		dash_spawn.shoot()


func get_direction():
	var horizontal = Input.get_action_strength("move_right" + action_suffix) - Input.get_action_strength("move_left" + action_suffix)
	if abs(horizontal) < JOYSTICK_POWER_THRESHOLD: 
		horizontal = 0 
	else: 
		horizontal = sign(horizontal)
	var vertical = -1 if is_on_floor() and Input.is_action_just_pressed("jump" + action_suffix) else 0
	if horizontal == 0 and dash:
		horizontal = last_horizontal_direction
	if abs(horizontal) > 0:
		last_horizontal_direction = horizontal
	return Vector2(horizontal, vertical)


# This function calculates a new velocity whenever you need it.
# It allows you to interrupt jumps.
func calculate_move_velocity(
		linear_velocity,
		direction,
		speed,
		is_jump_interrupted
	):
	var velocity = linear_velocity
	velocity.x = speed.x * direction.x
	if dash:
		velocity.x = velocity.x*DASH_MULTIPLIER
	if direction.y != 0.0:
		velocity.y = speed.y * direction.y
	if is_jump_interrupted:
		velocity.y = 0.0
	return velocity


func get_new_animation(is_shooting = false):
	var animation_new = "default"
	if is_on_floor():
		animation_new = "walk" if abs(_velocity.x) > 0.1 else "default"
	else:
		animation_new = "fall" if _velocity.y > 0 else "jump"
	if is_shooting:
		animation_new = "shoot"
	return animation_new


func _on_GhostSpacing_timeout():
	if dash:
		ghost_spawn.shoot(sprite)
