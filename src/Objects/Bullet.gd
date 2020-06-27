class_name Bullet
extends Area2D


onready var animation_player = $AnimationPlayer
var velocity:Vector2 = Vector2()
export var damage : int = 25
var nulled : bool = false;

func destroy():
	animation_player.play("destroy")


func _on_body_entered(body):
	if body is Enemy:
		body.damage(damage)
		self.queue_free()


func _process(delta):
	position = position + delta*velocity


func _on_Bullet_area_entered(area):
	if area is Shield:
		self.queue_free()

