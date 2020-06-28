extends Enemy

export(PackedScene) var enemy_scene_1
export(PackedScene) var enemy_scene_2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
func spawn_enemy():
	var en1 = enemy_scene_1.instance()
	var en2 = enemy_scene_2.instance()
	en1.global_position = global_position + Vector2(0,30)
	en2.global_position = global_position + Vector2(0,30)
	en1.set_as_toplevel(true)
	en2.set_as_toplevel(true)
	add_child(en1)
	add_child(en2)
	
func calculate_move_velocity(linear_velocity):
	pass
	
func cooler_physics_process(_delta):
	pass

func destroy():
	.destroy()
	.get_parent().get_node('AnimationPlayer').play('destroyed')


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'destroyed':
		get_tree().change_scene("res://WIN.tscn")
