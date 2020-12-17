class_name StackMachineState

var name = "state Superclass"
var host
var state_time = 0
var started = false

func on_start(args = []):
	pass

func on_end(args = []):
	pass

func process(delta, args = []):
	pass

func get_name() -> String:
	return name
