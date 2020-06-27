extends HBoxContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	Score.connect("score_increased", self, "update_score")
	update_score()

func update_score():
	$Score.text = str(Score.score).pad_zeros(12)
