extends Bullet
class_name WaveBullet

const RADIAN_INCREMENT = PI/4.0
const AMPLITUDE = 40
const AMPLITUDE_INCREMENT = 0.1

var offset = 0
var amplitude_multiplier = 1.0
func _process(delta):
	position = position + (delta*velocity + amplitude_multiplier*AMPLITUDE*Vector2(0, sin(offset)))
	offset+= RADIAN_INCREMENT
	amplitude_multiplier += AMPLITUDE_INCREMENT
	
