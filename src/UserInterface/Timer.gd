extends HBoxContainer


func _ready():
	GameTimer.connect("time_changed", self, "update_time")
	
func update_time():
	var minutes:int = int(GameTimer.seconds/60)
	var seconds:int = GameTimer.seconds - minutes*60
	$Time.text = str(minutes).pad_zeros(2) + ":"+ str(seconds).pad_zeros(2)
