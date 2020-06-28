extends Timer


var seconds = 0

signal time_changed

func start_counting():
	start()

func _on_Timer_timeout():
	seconds += 1
	emit_signal("time_changed")
	
func stop_counting():
	stop()

func reset():
	seconds = 0
