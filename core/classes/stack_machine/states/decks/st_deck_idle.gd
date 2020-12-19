extends StackMachineState

# host = Entity using the state
# args = arguments provided for state
# state_time = time in seconds we have been in this state

# Have process return 1 or -1 when the state is finished,
# otherwise return 0 to continue

func _init() -> void:
	name = "Deck - Idle"

# Run once when the state starts
func on_start(): 
	pass

# Run once when the state is finished
func on_end(): 
	pass

# Usually called each step of the host, but can be called to run whenever
func process(delta): 
	# return 0 to continue in this state
	# return 1 to end state, return -1 to end state and process next state right away
	return 1
