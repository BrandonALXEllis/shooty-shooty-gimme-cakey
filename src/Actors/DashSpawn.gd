class_name DashSpawn
extends Position2D

onready var sound_dash = $Dash
const DashParticles = preload("res://src/Objects/DashParticles.tscn")


func shoot():
	var cloud = DashParticles.instance()
	#cloud.global_position = global_position
	#cloud.global_scale = Vector2(global_scale.y, global_scale.x) #For some reason, scale is messed up

	# cloud.set_as_toplevel(true)
	add_child(cloud)
	sound_dash.play()
	return true
