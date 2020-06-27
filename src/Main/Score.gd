extends Node

var hit_combo = 0

# We should probably use a mutex here... nah
func increment_combo():
	hit_combo += 1

func reset_combo():
	hit_combo = 0
