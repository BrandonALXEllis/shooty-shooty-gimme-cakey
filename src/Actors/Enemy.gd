class_name Enemy
extends Actor


enum State {
	WALKING,
	DEAD
}

export(bool) var does_move = true
export(bool) var does_jump = false
export(bool) var does_fly = false
export(bool) var does_chase = true
export(int) var max_health  = 1000
export(float) var chase_speed = 1
export(float) var jump_speed = 1.5
export(float) var seek_radius = 100
export(int) var score_per_hit = 10
export(int) var score_destroy_bonus = 1000
export(int) var num_powerups = 1
var health = max_health
var jumping = false;
var flying = false;
var saved_velocity_x = 0
var last_dir = 1
var saved_velocity = Vector2(0,0)
var idle_anim_time = 0
var changed_hit_color = 0;
var changed_hit_color_max = 3;

var _state = State.WALKING

onready var platform_detector = $PlatformDetector
onready var floor_detector_left = $FloorDetectorLeft
onready var floor_detector_right = $FloorDetectorRight
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var healthbar = $HealthDisplay
onready var jump_timer = $JumpTimer

#player object on detection for chasing.
var player = null
const PowerDrop = preload("res://src/Objects/PowerDrop.tscn")

# This function is called when the scene enters the scene tree.
# We can initialize variables here.
func _ready():
	$DetectRadius/CollisionShape2D.shape.radius = seek_radius
	print($DetectRadius/CollisionShape2D.shape.radius)
	_velocity.x = speed.x
	healthbar.init(health, max_health)
	if (does_jump):
		jump_timer.start()

# Physics process is a built-in loop in Godot.
# If you define _physics_process on a node, Godot will call it every frame.

# At a glance, you can see that the physics process loop:
# 1. Calculates the move velocity.
# 2. Moves the character.
# 3. Updates the sprite direction.
# 4. Updates the animation.

# Splitting the physics process logic into functions not only makes it
# easier to read, it help to change or improve the code later on:
# - If you need to change a calculation, you can use Go To -> Function
#   (Ctrl Alt F) to quickly jump to the corresponding function.
# - If you split the character into a state machine or more advanced pattern,
#   you can easily move individual functions.
func _physics_process(_delta):
	_velocity = calculate_move_velocity(_velocity)

	# We only update the y value of _velocity as we want to handle the horizontal movement ourselves.
	_velocity.y = move_and_slide(_velocity, FLOOR_NORMAL).y

	# We flip the Sprite depending on which way the enemy is moving.
	if does_fly:
		if !!player && !flying:
			#sprite.scale.x = -sign(position.direction_to(player.position).x)
			pass
	elif !does_jump:
		sprite.scale.x = -1 if _velocity.x > 0 else 1
	else:
		pass
		# scale.x = -sign(saved_velocity_x)

	var animation = get_new_animation()
	if animation != animation_player.current_animation:
		if animation_player.current_animation == 'idle':
			idle_anim_time = animation_player.current_animation_position
		animation_player.play(animation)
		if animation == 'idle':
			animation_player.seek(idle_anim_time)
		
func _process(delta):
	if changed_hit_color:
		changed_hit_color += 1
		if changed_hit_color > changed_hit_color_max:
			modulate = Color.white

# This function calculates a new velocity whenever you need it.
# If the enemy encounters a wall or an edge, the horizontal velocity is flipped.
func calculate_move_velocity(linear_velocity):
	var velocity = linear_velocity
			
	# Follow player correctly
	if player && does_chase:
		if does_jump:
			if is_on_floor():
				saved_velocity_x = (sign(position.direction_to(player.position).x) * chase_speed*speed.x)
		elif does_fly:
			if $FlyTimer.is_stopped():
				flying = true
				$FlyTimer.start()
		else:
			if is_on_floor():
				velocity.x = (sign(position.direction_to(player.position).x) * chase_speed*speed.x)
	
	if does_jump:
		if !jumping:
			#Velocity should only depend on if we are in the air or not.
			if is_on_floor():
				if velocity.x != 0:
					saved_velocity_x = velocity.x
					velocity.x = 0;
		else:
			#if we did jump, boost in air
			velocity.y = -speed.y*jump_speed
			jumping = false;
			
			if not floor_detector_left.is_colliding():
				velocity.x = speed.x
				saved_velocity_x = velocity.x
			elif not floor_detector_right.is_colliding():
				velocity.x = -speed.x
				saved_velocity_x = velocity.x
			else:
				velocity.x = saved_velocity_x
	else:
		if does_fly:
			# It should follow a figure 8 path until it sees the player
			# If it does find the player, it should head towards it with constant
			# velocity and direction.
			#
			if flying:
				velocity = saved_velocity
			else:
				velocity = Vector2(0,0)
		else:
			if not floor_detector_left.is_colliding():
				velocity.x = speed.x
			elif not floor_detector_right.is_colliding():
				velocity.x = -speed.x

	if is_on_wall():
		velocity.x *= -1
		
	# Freeeze enemy if not moving
	if !does_move:
		velocity.x = 0

	return velocity

func damage(amount):
	health -= amount
	healthbar.update_healthbar(health)
	modulate= Color.yellow
	changed_hit_color = 1
	$Hit.play()
	Score.increment_score(score_per_hit)
	if health <=0:
		Score.increment_score(score_destroy_bonus)
		self.destroy()

func destroy():
	_state = State.DEAD
	_velocity = Vector2.ZERO
	drop_powerups()


func drop_powerups():
	for i in range(num_powerups):
			var drop = PowerDrop.instance()
			drop.global_position = global_position + Vector2(rand_range(-15, 15), rand_range(-15, 15))
			drop.call_deferred("set_as_toplevel", true)
			get_parent().call_deferred("add_child", drop)

func get_new_animation():
	var animation_new = ""
	if _state == State.WALKING:
		animation_new = "walk" if abs(_velocity.x) > 0 else "idle"
	else:
		animation_new = "destroy"
	return animation_new

func jump():
	if does_jump:
		jumping = true;

func _on_JumpTimer_timeout():
	jump()



func _on_DetectRadius_body_entered(body):
	if body is Player:
		player = body


func _on_DetectRadius_body_exited(body):
	if body == player:
		player = null
		_velocity.x = speed.x*sign(_velocity.x)


func _on_FlyTimer_timeout():	
	if flying:
		$FlyTimer.start(.3)
		if !player:
			$FlyTimer.stop()
	
	#If done flying, stop.
	elif !flying:
		$FlyTimer.start(1)
		#determine new velocity to fly in
		if player && does_chase:
			sprite.scale.x = -sign(position.direction_to(player.position).x)
			saved_velocity = position.direction_to(player.position + Vector2(0,-20)) * chase_speed*speed
		else:
			saved_velocity = Vector2(0,0)
			
	flying = !flying
