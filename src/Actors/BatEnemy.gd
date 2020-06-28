extends Enemy


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


func _on_FlyTimer_timeout():	
	if flying:
		$FlyTimer.wait_time = .3
		if !player:
			$FlyTimer.stop()
	
	#If done flying, stop.
	elif !flying:
		$FlyTimer.wait_time = 1
		print("flying")
		#determine new velocity to fly in
		if player && does_chase:
			saved_velocity = position.direction_to(player.position + Vector2(0,-20)) * chase_speed*speed
		else:
			saved_velocity = Vector2(0,0)
			
	flying = !flying
