extends HBoxContainer

var node:Node
var method:String
var description:String

signal focused

func set_data(label:String, xdescription:String, caller:Node, xmethod:String):
	$Label.text = label
	description = xdescription
	node = caller
	method = xmethod

func _ready():
	$Label/Polygon2D/AnimationPlayer.play("Wipe")
	$Label/Polygon2D/AnimationPlayer.seek($Label/Polygon2D/AnimationPlayer.current_animation_length, true)
	$Label/Polygon2D/AnimationPlayer.stop()

func focus():
	$Label/Button.grab_focus()

func on_focus():
	emit_signal("focused")
	$Focus.play()
	$Label/Polygon2D/AnimationPlayer.play_backwards("Wipe")
	
func leave_focus():
	$Label/Polygon2D/AnimationPlayer.play("Wipe")

func on_press():
	$Select.play()
	node.call(method)
