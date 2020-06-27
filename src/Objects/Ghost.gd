extends Sprite

func _ready():
	$Tween.interpolate_property(self, "modulate", Color.gray, Color.transparent, 0.6, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	
func _on_Tween_tween_completed(object, key):
	queue_free()
