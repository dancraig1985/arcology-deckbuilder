class_name StackMachineState

var name = "state Superclass"
var host: Node
var args: Dictionary = {}
var state_time = 0
var state_env: Dictionary = {} # < - Use to store info local to state
var started = false


func on_start() -> void:
	pass

func process(delta) -> void:
	pass

func on_end() -> void:
	pass

func get_name() -> String:
	return name
