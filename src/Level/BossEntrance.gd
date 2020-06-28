extends Area2D

const BOSS_SCENE = "res://src/Main/BossGame.tscn"

func _on_BossEntrance_body_entered(body):
	if body.is_in_group("player"):
		SceneChanger.change_scene(BOSS_SCENE)
