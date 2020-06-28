extends Node2D

export(PackedScene) var coinlineScene

func _ready():
	respawn()

func respawn():
	print("respawned")
	for child in get_children():
		child.queue_free()
	var new = coinlineScene.instance()
	new.position = Vector2(0,0)
	add_child(new)
