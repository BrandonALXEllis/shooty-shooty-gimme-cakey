extends Bullet

func _on_body_entered(body):
	print(body)
	if body is Player:
		body.damage(damage)
		body._velocity = Vector2(0,0)
		self.queue_free()
		
