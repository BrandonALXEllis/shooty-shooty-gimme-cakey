extends AudioStreamPlayer

func _ready():
	play()

func _on_ExperienceSFX_finished():
	queue_free()
