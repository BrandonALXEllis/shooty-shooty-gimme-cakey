class_name Bullet
extends Area2D


onready var animation_player = $AnimationPlayer
var velocity:Vector2 = Vector2()

func destroy():
	animation_player.play("destroy")


func _on_body_entered(body):
	if body is Enemy:
		body.destroy()

func _process(delta):
	position = position + delta*velocity
