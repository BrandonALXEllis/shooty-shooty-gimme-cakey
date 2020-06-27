class_name Enemy
extends Actor


enum State {
	WALKING,
	DEAD
}

export(bool) var does_move = true
export(bool) var does_jump = false
export(int) var max_health  = 1000
export(int) var score_per_hit = 10
export(int) var score_destroy_bonus = 1000
var health = max_health
var jumping = false;

var _state = State.WALKING

onready var platform_detector = $PlatformDetector
onready var floor_detector_left = $FloorDetectorLeft
onready var floor_detector_right = $FloorDetectorRight
onready var sprite = $Sprite
onready var animation_player = $AnimationPlayer
onready var healthbar = $HealthDisplay
onready var jump_timer = $JumpTimer


# This function is called when the scene enters the scene tree.
# We can initialize variables here.
func _ready():
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
	sprite.scale.x = 1 if _velocity.x > 0 else -1

	var animation = get_new_animation()
	if animation != animation_player.current_animation:
		animation_player.play(animation)


# This function calculates a new velocity whenever you need it.
# If the enemy encounters a wall or an edge, the horizontal velocity is flipped.
func calculate_move_velocity(linear_velocity):
	var velocity = linear_velocity
	
	if does_jump && jumping:
		velocity.y = -speed.y
		jumping = false;

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
	Score.increment_score(score_per_hit)
	if health <=0:
		Score.increment_score(score_destroy_bonus)
		self.destroy()

func destroy():
	_state = State.DEAD
	_velocity = Vector2.ZERO


func get_new_animation():
	var animation_new = ""
	if _state == State.WALKING:
		animation_new = "walk" if abs(_velocity.x) > 0 else "idle"
	else:
		animation_new = "destroy"
	return animation_new

func jump():
	jumping = true;

func _on_JumpTimer_timeout():
	jump()

