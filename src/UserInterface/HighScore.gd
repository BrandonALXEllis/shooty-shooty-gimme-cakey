extends Label

func _ready():
	text = "HI SCORE:" + str(Score.hiscore).pad_zeros(12)
