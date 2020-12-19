extends StackMachineState

# host = Entity using the state
# args = arguments provided for state
# state_time = time in seconds we have been in this state
# state_env = {} < - Use to store info local to state

# Have process return 1 or -1 when the state is finished,
# otherwise return 0 to continue

func _init() -> void:
	name = "Card - Idle"

# Run once when the state starts
func on_start(): 
	host.is_acting = false

# Usually called each step of the host, but can be called to run whenever
func process(delta): 
	return 1

# Run once when the state is finished
func on_end(): 
	pass


