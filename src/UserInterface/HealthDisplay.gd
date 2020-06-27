extends Node2D


export(Texture) var bar_red;
export(Texture) var bar_green;
export(Texture) var bar_yellow;

onready var healthbar = $HealthBar

	
func init(health, max_health):
	if health >= max_health:
		hide()
	healthbar.max_value = max_health
	healthbar.value = health

func _process(delta):
	global_rotation = 0

func update_healthbar(value):
	healthbar.texture_progress = bar_green
	if value < healthbar.max_value * 0.7:
		healthbar.texture_progress = bar_yellow
	if value < healthbar.max_value * 0.35:
		healthbar.texture_progress = bar_red
	if value < healthbar.max_value:
		show()
	healthbar.value = value
