extends Spatial


# A simple script to rotate the model.
const SPEED = 40

func _process(delta):
	rotation_degrees.y += delta * SPEED
