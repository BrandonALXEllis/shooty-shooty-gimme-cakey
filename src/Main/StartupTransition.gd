extends Control

export (String) var target = "res://src/Main/TitleScene.tscn"

var pressed = false

func _ready():
	$Cover.modulate = Color.white
	$AnimationPlayer.play("Activate")
	$Button.grab_focus()


func _on_Button_pressed():
	if pressed: return
	pressed = true
	$AnimationPlayer.stop()
	$AnimationPlayer.play_backwards("Activate")
	yield($AnimationPlayer, "animation_finished")
	SceneChanger.change_scene(target)
