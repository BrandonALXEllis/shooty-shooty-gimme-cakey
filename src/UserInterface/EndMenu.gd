extends Control


func _ready():
	hide()

const Game = "res://src/Main/Game.tscn"
const TitleScene = "res://src/Main/TitleScene.tscn"

func popup():
	show()
	$VBoxContainer/RestartButton.grab_focus()

func _on_QuitButton_pressed():
	get_tree().paused = false
	SceneChanger.change_scene(TitleScene)


func _on_RestartButton_pressed():
	get_tree().paused = false
	SceneChanger.change_scene(Game)
