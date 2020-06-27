class_name GhostSpawn
extends Position2D


const Ghost = preload("res://src/Objects/Ghost.tscn")


func shoot(sprite: AnimatedSprite):
	var ghost = Ghost.instance()
	ghost.global_position = global_position
	ghost.texture = sprite.frames.get_frame(sprite.animation, sprite.frame)
#	ghost.hframes = sprite.hframes
#	ghost.vframes = sprite.vframes
#	ghost.frame = sprite.frame
	ghost.scale = sprite.scale

	ghost.set_as_toplevel(true)
	add_child(ghost)
	return true

