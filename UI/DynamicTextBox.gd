extends Control

onready var textbox = $PanelContainer/Label
var text = "sample text"
var update_delta = 0.5
var acc_delta = 0.0

func _process(delta):
	acc_delta += delta
	if acc_delta > update_delta:
		step()
		acc_delta = 0
		
func step():
	textbox.text = textbox.text.substr(1) + textbox.text.substr(0,1)

func set_text(text):
	textbox.text = "  " + text + " "
	textbox.text += textbox.text
	textbox.text += textbox.text
	textbox.text += textbox.text
