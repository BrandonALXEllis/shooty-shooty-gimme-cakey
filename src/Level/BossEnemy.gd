extends Actor
class_name BossEnemy


enum State {
	WALKING,
	DEAD
}

export(bool) var does_move = true
export(bool) var does_jump = false
export(bool) var does_fly = false
export(bool) var does_chase = true
export(int) var max_health  = 10
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
onready var healthbar = $HealthDisplay
onready var sprite = $Sprite
var _state = State.WALKING

#player object on detection for chasing.
var player = null
const PowerDrop = preload("res://src/Objects/PowerDrop.tscn")
	

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
	cooler_physics_process(_delta)
		
func _process(delta):
	if changed_hit_color:
		changed_hit_color += 1
		if changed_hit_color > changed_hit_color_max:
			modulate = Color.white

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


export(PackedScene) var enemy_scene_1
export(PackedScene) var enemy_scene_2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func spawn_enemy():
	var en1 = enemy_scene_1.instance()
	var en2 = enemy_scene_2.instance()
	en1.global_position = global_position + Vector2(0,30)
	en2.global_position = global_position + Vector2(0,30)
	en1.set_as_toplevel(true)
	en2.set_as_toplevel(true)
	add_child(en1)
	add_child(en2)
	
func calculate_move_velocity(linear_velocity):
	pass
	
func cooler_physics_process(_delta):
	pass

func destroy():
	_state = State.DEAD
	_velocity = Vector2.ZERO
	drop_powerups()
	.get_parent().get_node('AnimationPlayer').play('destroyed')


func _on_AnimationPlayer_animation_finished(anim_name):
	print("help")
	if anim_name == 'destroyed':
		Global.trigger_win()
