class_name Heart
extends Area2D
# Collectible that disappears when the player touches it.

onready var animation_player = $AnimationPlayer
export(int) var health = 15
var picked : bool = false

func _on_body_entered(_body):
	if !picked && _body is Player:
		animation_player.play("picked")
		picked = true
		Score.increment_hp(health)
