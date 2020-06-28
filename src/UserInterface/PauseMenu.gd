extends Control


onready var resume_button = $VBoxContainer/ResumeButton
const Game = "res://src/Main/Game.tscn"
const TitleScene = "res://src/Main/TitleScene.tscn"

func _ready():
	visible = false


func close():
	visible = false


func open():
	visible = true
	resume_button.grab_focus()


func _on_ResumeButton_pressed():
	get_tree().paused = false
	visible = false


func _on_QuitButton_pressed():
	get_tree().paused = false
	SceneChanger.change_scene(TitleScene)


func _on_RestartButton_pressed():
	get_tree().paused = false
	SceneChanger.change_scene(Game)
