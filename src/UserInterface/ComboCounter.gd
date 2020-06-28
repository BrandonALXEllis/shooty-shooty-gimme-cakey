extends VBoxContainer

const COMBO_DURATION = 3.0

const flavor_stages = {
	"0": {
		"text": "Cool!",
		"color": Color.white,
		"outline_color": Color.white
	},
	"100": {
		"text": "Nice!!",
		"color": Color.white,
		"outline_color": Color.black
	},
	"500": {
		"text": "Great!",
		"color": Color.yellow,
		"outline_color": Color.black
	},
	"1000": {
		"text": "Amazing!",
		"color": Color.green,
		"outline_color": Color.black
	},
	"99999999999999": {
		"text": "WOAH!",
		"color": Color.pink,
		"outline_color": Color.black
	},
}

onready var combo_label = $Combo
onready var flavor_text:Label = $Flavor
onready var multiplier_label = $HBoxContainer/MultiplierScore

func _ready():
	Score.connect("combo_increased", self, "update_score")
	Score.connect("combo_force_reset", self, "hide_combo")
	modulate = Color.transparent

func set_flavor_text(score):
	for key in flavor_stages.keys():
		if score < key.to_int():
			flavor_text.text = flavor_stages[key]["text"]
			flavor_text.set("custom_colors/font_color",flavor_stages[key]["color"])
			flavor_text.set("custom_colors/font_outline_modulate",flavor_stages[key]["outline_color"])
			return

func update_score():
	var score = Score.hit_combo
	combo_label.text = str(score)
	multiplier_label.text =   str(Score.damage_multiplier).pad_decimals(1) + "x"
	set_flavor_text(score)
	$Combo/AnimationPlayer.stop(true)
	$Combo/AnimationPlayer.play("Activate")
	$Tween.stop_all()
	$Tween.interpolate_property(self, "modulate", Color.white, Color.transparent, COMBO_DURATION, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	$Tween.start()
	
func _on_Tween_tween_completed(object, key):
	Score.reset_combo()

func hide_combo():
	$Tween.stop_all()
	modulate = Color.transparent
