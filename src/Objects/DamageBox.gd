extends Area2D

export(float) var amount = 10;
var player = null


#Hurt player every frame.
func _process(delta):
	if player:
		player.damage(amount)

func _on_DamageBox_body_entered(body):
	if body is Player:
		player = body;

func _on_DamageBox_body_exited(body):
	if !!player && body == player:
		player = null
