extends Enemy


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(_delta):
	._physics_process(_delta)
	if does_jump:
		if !is_on_floor() && $Sprite.animation != 'jump':
			$Sprite.play("jump")
		elif is_on_floor() && $Sprite.animation != 'default':
			$Sprite.play("default")


func _on_Shield_area_entered(area):
	does_move = false
	does_jump = false
	$Sprite.play("block")
	$BlockTimer.start()
	$Miss.play()
	


func _on_BlockTimer_timeout():
	does_move = true
	does_jump = true
	$Sprite.play("default")
