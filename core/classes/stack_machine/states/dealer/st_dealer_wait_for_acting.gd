extends StackMachineState

# host = Entity using the state
# args = arguments provided for state
# state_time = time in seconds we have been in this state

# Have process return 1 or -1 when the state is finished,
# otherwise return 0 to continue

func _init() -> void:
	name = "Dealer - Waiting for Acting"

# Run once when the state starts
func on_start():
	pass

# Usually called each step of the host, but can be called to run whenever
func process(delta):
	var draw_delay = Constants.OP_DEALER_BOARD_ACTION_DELAY
	if state_time > draw_delay and not host.get_is_any_actor_acting():
		return 1
	return 0

# Run once when the state is finished
func on_end(): 
	pass
