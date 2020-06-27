class_name Gun
extends Position2D
# Represents a weapon that spawns and shoots bullets.
# The Cooldown timer controls the cooldown duration between shots.


const BULLET_VELOCITY = 500.0
const Bullet = preload("res://src/Objects/Bullet.tscn")

onready var sound_shoot = $Shoot
onready var timer = $Cooldown #lol unused


func shoot(direction = 1):
	if not timer.is_stopped():
		return false
	var bullet = Bullet.instance()
	bullet.global_position = global_position
	bullet.velocity = Vector2(direction * BULLET_VELOCITY, 0)
	var bullet2 = Bullet.instance()
	bullet2.modulate = Color.red
	bullet2.global_position = global_position + Vector2(2, -15)
	bullet2.velocity = Vector2(direction * BULLET_VELOCITY, 0)
	var bullet3 = Bullet.instance()
	bullet3.modulate = Color.blueviolet
	bullet3.global_position = global_position + Vector2(2, 15)
	bullet3.velocity = Vector2(direction * BULLET_VELOCITY, 0)

	bullet.set_as_toplevel(true)
	add_child(bullet)
	bullet2.set_as_toplevel(true)
	add_child(bullet2)
	bullet3.set_as_toplevel(true)
	add_child(bullet3)
	sound_shoot.play()
	return true
