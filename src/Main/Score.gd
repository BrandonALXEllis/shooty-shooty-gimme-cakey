extends Node

const DAMAGE_CAP = 10.0
const DAMAGE_PER_COMBO = 1.0/100.0

var hit_combo = 0
var damage_multiplier = 1.0
var score = 0
signal combo_increased
signal combo_force_reset
signal score_increased

# We should probably use a mutex here... nah
func increment_combo():
	hit_combo += 1
	damage_multiplier += DAMAGE_PER_COMBO
	if damage_multiplier > DAMAGE_CAP:
		damage_multiplier = DAMAGE_CAP
	emit_signal("combo_increased")
	
func increment_score(amount):
	score += amount
	emit_signal("score_increased")

func reset_combo():
	hit_combo = 0
	damage_multiplier = 1.0

func force_combo_reset():
	reset_combo()
	emit_signal("combo_force_reset")
