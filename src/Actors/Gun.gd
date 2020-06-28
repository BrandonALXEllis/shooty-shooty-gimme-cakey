class_name Gun
extends Position2D
# Represents a weapon that spawns and shoots bullets.
# The Cooldown timer controls the cooldown duration between shots.


const BULLET_VELOCITY = 500.0
const BULLET_ALPHA = 0.5
const Bullet = preload("res://src/Objects/Bullet.tscn")
const WaveBullet = preload("res://src/Objects/WaveBullet.tscn")

onready var sound_shoot = $Shoot

var level = 1

func interpolate_color(color1:Color, color2:Color, t):
	var color = color1.linear_interpolate(color2,t)
	color.a = BULLET_ALPHA
	return color

func shoot(direction = 1):
	match(Score.get_level()):
		1:
			level_1_shoot(direction)
			sound_shoot.pitch_scale = 2.0
		2:
			level_1_shoot(direction)
			level_2_shoot(direction)
			sound_shoot.pitch_scale = 2.5
		3:
			level_1_shoot(direction)
			level_2_shoot(direction)
			level_3_shoot(direction)
			sound_shoot.pitch_scale = 3.0
		4:
			level_1_shoot(direction)
			level_2_shoot(direction)
			level_3_shoot(direction)
			level_4_shoot(direction)
			sound_shoot.pitch_scale = 3.5
		5:
			level_1_shoot(direction)
			level_2_shoot(direction)
			level_3_shoot(direction)
			level_4_shoot(direction)
			level_5_shoot(direction)
			sound_shoot.pitch_scale = 4.0
	sound_shoot.play()
	return true
	
func spawn_bullet(spawn:Position2D, direction, color):
	var bullet = Bullet.instance()
	bullet.modulate = color
	bullet.global_position = spawn.global_position
	bullet.velocity = Vector2(direction * BULLET_VELOCITY, 0).rotated(spawn.rotation*direction)
	bullet.set_as_toplevel(true)
	spawn.add_child(bullet)
	
func spawn_wave_bullet(spawn:Position2D, direction, offset, color):
	var bullet = WaveBullet.instance()
	bullet.modulate = color
	bullet.global_position = spawn.global_position
	bullet.velocity = Vector2(direction * BULLET_VELOCITY, 0).rotated(spawn.rotation*direction)
	bullet.offset = offset
	bullet.set_as_toplevel(true)
	spawn.add_child(bullet)

func level_1_shoot(direction):
	spawn_bullet($Gun1, direction, interpolate_color(Color.white, Color.red, Score.damage_multiplier_ratio)) 
	
func level_2_shoot(direction):
	spawn_bullet($Gun2Top, direction, interpolate_color(Color.white, Color.orange, Score.damage_multiplier_ratio))
	spawn_bullet($Gun2Bottom, direction, interpolate_color(Color.white, Color.orange, Score.damage_multiplier_ratio))
	
func level_3_shoot(direction):
	spawn_bullet($Gun3Top, direction, interpolate_color(Color.white, Color.blue, Score.damage_multiplier_ratio))
	spawn_bullet($Gun3Bottom, direction, interpolate_color(Color.white, Color.blue, Score.damage_multiplier_ratio))
	
func level_4_shoot(direction):
	spawn_bullet($Gun4Top, direction, interpolate_color(Color.white, Color.purple, Score.damage_multiplier_ratio))
	spawn_bullet($Gun4Bottom, direction, interpolate_color(Color.white, Color.purple, Score.damage_multiplier_ratio))

func level_5_shoot(direction):
	spawn_wave_bullet($Gun5Top, direction, PI/2.0, interpolate_color(Color.white, Color.white, Score.damage_multiplier_ratio))
	spawn_wave_bullet($Gun5Bottom, direction, -PI/2.0, interpolate_color(Color.white, Color.white, Score.damage_multiplier_ratio))

