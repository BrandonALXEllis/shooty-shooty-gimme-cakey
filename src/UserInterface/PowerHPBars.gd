extends VBoxContainer

var current_level = 1

const LevelParticles = preload("res://src/Objects/LevelParticles.tscn")

func _ready():
	Score.connect("level_changed", self, "update_power")
	Score.connect("hp_changed", self, "update_hp")
	update_power()
	$HBoxContainer/Power.tint_progress = Color.lightskyblue
	
func update_hp():
	$HBoxContainer/Hp/Hp2.value = Score.get_hp_percentage()
	
	#Change animation
	$HBoxContainer/Hp/AnimationPlayer.stop(true)
	var anim:Animation = 	$HBoxContainer/Hp/AnimationPlayer.get_animation("Change")
	anim.track_set_key_value( 0, 0,  $HBoxContainer/Hp.value)
	anim.track_set_key_value( 0, 1,  Score.get_hp_percentage())
	$HBoxContainer/Hp/AnimationPlayer.play("Change")

func update_power():
	$HBoxContainer/Power.value = Score.get_level_progress()
	update_level()
	
func update_level():
	var level = Score.get_level()
	if level != current_level:
		$HBoxContainer2/Level.text = str(level)
		if level > current_level:
			var particles = LevelParticles.instance()
			$HBoxContainer2/Level/Position2D.add_child(particles)
			$HBoxContainer/Power/LevelUp.stop()
			$HBoxContainer/Power/LevelUp.play()
		if level == 5:
			$HBoxContainer/Power/AnimationPlayer.play("Activate")
			$HBoxContainer2/Level.modulate = Color.lightskyblue
		else:
			$HBoxContainer/Power/AnimationPlayer.stop()
			$HBoxContainer/Power.tint_progress = Color.lightskyblue
			$HBoxContainer2/Level.modulate = Color.white
			
		current_level = level
		
