extends Control

var choices = []

signal update_description

# Called when the node enters the scene tree for the first time.
func set_data(options, caller):
	# Populate options according to settings above
	var counter = 1
	for option in options:
		var target = $VBoxContainer.get_node(str(counter))
		target.set_data(options[counter-1]["Name"], options[counter-1]["Description"], caller, options[counter-1]["Method"])
		target.connect("focused", self, "on_new_focus", [target])
		choices.append(target)
		counter+=1
		
func focus(index):
	choices[index].focus()
	
func on_new_focus(choice):
	print("on_new_focus")
	emit_signal("update_description", choice.description)
		
