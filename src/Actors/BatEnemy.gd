extends Enemy


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export(bool) var can_shoot = true
export(PackedScene) var bullet_scene


func _on_FlyTimer_timeout():	
	if flying:
		$FlyTimer.wait_time = .3
		if !player:
			$FlyTimer.stop()
	
	#If done flying, stop.
	elif !flying:
		$FlyTimer.wait_time = 1
		#determine new velocity to fly in
		if player && does_chase:
			#sprite.scale.x = -sign(position.direction_to(player.position).x)
			saved_velocity = position.direction_to(player.position + Vector2(0,-20)) * chase_speed*speed
		else:
			saved_velocity = Vector2(0,0)
			
	flying = !flying


func _on_Shoot_timer_timeout():
	#Spawn enemy bullet towards player
	if player:
		$Sprite.play("attack")

func actually_shoot():
	if player:
		var bull = bullet_scene.instance()
		bull.global_position = global_position
		bull.velocity = global_position.direction_to(player.global_position) * chase_speed*speed*2
		bull.set_as_toplevel(true)
		add_child(bull)

func _on_Sprite_animation_finished():
	if $Sprite.animation == 'attack':
		actually_shoot()
		$Sprite.play('default')
