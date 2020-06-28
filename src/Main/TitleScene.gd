extends Control

const Game = "res://src/Main/Game.tscn"

const options = [
	{
		"Name" : "Play",
		"Description" : "Play the game! Watch epic battles unfold as you take down the demon overlord of birthday parties!",
		"Method" : "function1"
	},
	{
		"Name" : "Credits",
		"Description" : "See who actually made the game and give credit where it's due.",
		"Method" : "function2"
	},
	{
		"Name" : "Quit",
		"Description" : "Please don't pick this one",
		"Method" : "function3"
	}	
]

func function1():
	SceneChanger.change_scene(Game)

func function2():
	print("Option 2 Pressed!")

func function3():
	get_tree().quit()


func update_description(description):
	print("Hellow world")
	$DynamicTextBox.set_text(description)

func _ready():
	$Choices.set_data(options, self)
	$Choices.connect("update_description", self, "update_description")
	$Choices.focus(0)
