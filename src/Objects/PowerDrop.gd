extends Sprite
class_name PowerDrop

var target:Player
const SPEED = 5
const ExperienceSFX = preload("res://src/Objects/ExperienceSFX.tscn")

func _ready():
	target = get_tree().get_nodes_in_group("player")[0]


#We have to add -10 so it gets the center of the player
func get_direction():
	return (target.global_position + Vector2(0, -10) - global_position).normalized()
	
func _physics_process(delta):
	position += SPEED*get_direction()

func _on_Area2D_body_entered(body):
	if body == target:
		Score.increment_level_points()
		var sfx = ExperienceSFX.instance()
		body.call_deferred("add_child", sfx)
		queue_free()
