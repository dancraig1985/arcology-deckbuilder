extends StackMachineState

# host = Entity using the state
# state_time = time in seconds we have been in this state

# Have process return 1 or -1 when the state is finished,
# otherwise return 0 to continue

func _init():
	name = "Card - Idle"

# Run once when the state starts
func on_start(args = []): 
	pass

# Run once when the state is finished
func on_end(args = []): 
	pass

# Usually called each step of the host, but can be called to run whenever
func process(delta, args = []): 
	# return 0 to continue in this state
	# return 1 to end state, return -1 to end state and process next state right away
	return 0
