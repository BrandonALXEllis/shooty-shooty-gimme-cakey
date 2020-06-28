extends Node

signal game_over
signal stop_music

func trigger_game_over():
	emit_signal("game_over")

func cut_music():
	emit_signal("stop_music")
