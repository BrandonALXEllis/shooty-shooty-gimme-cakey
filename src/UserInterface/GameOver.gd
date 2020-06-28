extends Label


func _ready():
	hide()
	percent_visible = 0
	Global.connect("game_over", self, "activate")
	
func activate():
	show()
	$AnimationPlayer.play("Activate")
	yield($AnimationPlayer, "animation_finished")
	$EndMenu.popup()
