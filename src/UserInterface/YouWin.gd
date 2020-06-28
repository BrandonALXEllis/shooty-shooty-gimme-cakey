extends Label

const target = 2*60

func _ready():
	hide()
	percent_visible = 0
	$Label.hide()
	$Label2.hide()
	Global.connect("you_win", self, "activate")
	
func activate():
	var multiplier = 1.0
	GameTimer.stop()
	if GameTimer.seconds < target:
		multiplier = 2.0
	elif GameTimer.seconds > 2*target:
		multiplier = 1.0
	else:
		multiplier = (GameTimer.seconds - target)/target + 1.0
		multiplier = str(multiplier).pad_decimals(1).to_float()
	Score.score = Score.score * multiplier
	Score.save_hi_score()	
	
	$Label.text = "TIME BONUS: " + str(multiplier).pad_decimals(1) + "x"
	$Label2.text = "TOTAL SCORE: " + str(Score.score)
	
	show()
	$AnimationPlayer.play("Activate")
	yield($AnimationPlayer, "animation_finished")
	$Label.show()
	$Timer.start()
	yield($Timer, "timeout")
	$Label2.show()
	$Timer.start()
	yield($Timer, "timeout")
	$EndMenu.popup()
