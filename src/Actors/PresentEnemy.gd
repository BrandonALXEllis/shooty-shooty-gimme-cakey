extends Enemy


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D2.disabled = false
	$DamageBox/CollisionShape2D.disabled = false
	collision_layer = 1024
