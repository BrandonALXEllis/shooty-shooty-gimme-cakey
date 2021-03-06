extends Node

const FILE_NAME = "user://game-data.json"

const DAMAGE_CAP = 10.0
const DAMAGE_PER_COMBO = 1.0/100.0
const MAX_HP = 100.0

var hit_combo = 0
var damage_multiplier = 1.0
var score = 0
var damage_multiplier_ratio = 0.0
var level_points = 0
var hp = 100.0
var hiscore = 0
var data = {}
var score_freeze = false

signal combo_increased
signal combo_force_reset
signal score_increased
signal level_changed
signal hp_changed
signal hp_zero

const level_stages = {
	"3": 1,
	"6": 2,
	"9": 3, 
	"12": 4,
}

func reset_hp():
	hp = MAX_HP
	emit_signal("hp_changed")

func reset_power():
	level_points = 0
	emit_signal("level_changed")


func freeze_score(enable):
	score_freeze = enable

func reset_score():
	score = 0

func save_hi_score():
	if score > hiscore:
		hiscore = score
	save_data()

func save_data():
	data["hiscore"] = hiscore
	var file = File.new()
	file.open(FILE_NAME, File.WRITE)
	file.store_string(to_json(data))
	file.close()

func load_data():
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME, File.READ)
		var new_data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			data = new_data
			hiscore = data["hiscore"]
		else:
			printerr("Corrupted data!")
	else:
		print("No saved data!")

func _ready():
	load_data()

func increment_hp(amount):
	hp += amount
	emit_signal("hp_changed")
	if hp <= 0:
		emit_signal("hp_zero")
		#Global.trigger_win()

func get_hp_percentage():
	return hp/MAX_HP

#This is an abomination of code efficiency, but we'll take it
func get_level():
	for key in level_stages.keys():
		if level_points < key.to_int():
			return level_stages[key]
	return 5 #max level
	
func get_level_progress():
	var min_points = 0
	var max_points = 0
	for key in level_stages.keys():
		if level_points < key.to_int():
			max_points = key.to_int()
			break
		else:
			min_points = key.to_int()
	if max_points == 0: 
		return 1
		
	var returny = float(level_points - min_points)/float(max_points-min_points)
	return returny
	
func increment_level_points():
	level_points+= 1
	emit_signal("level_changed")
			
# We should probably use a mutex here... nah
func increment_combo():
	hit_combo += 1
	damage_multiplier += DAMAGE_PER_COMBO
	if damage_multiplier > DAMAGE_CAP:
		damage_multiplier = DAMAGE_CAP
	damage_multiplier_ratio = (damage_multiplier - 1.0)/(DAMAGE_CAP - 1.0)
	emit_signal("combo_increased")
	
func increment_score(amount):
	if not score_freeze:
		score += amount
		emit_signal("score_increased")

func reset_combo():
	hit_combo = 0
	damage_multiplier = 1.0
	damage_multiplier_ratio = 0

func force_combo_reset():
	reset_combo()
	emit_signal("combo_force_reset")
