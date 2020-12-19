extends StackMachineState

# host = Entity using the state
# args = arguments provided for state
# state_time = time in seconds we have been in this state

# Have process return 1 or -1 when the state is finished,
# otherwise return 0 to continue

func _init() -> void:
	name = "Dealer - Game Start"

# Run once when the state starts
func on_start():
	host.spawn_cards_to_deck("Arcology Prime", 10, host.node_player_deck)
	host.spawn_cards_to_deck("Console Cowboy", 2,  host.node_player_deck)

# Usually called each step of the host, but can be called to run whenever
func process(delta): 
	if state_time > Constants.OP_DEALER_BOARD_ACTION_DELAY:
		host.add_state(Constants.ST_DEALER_TURN_START)
		return 1
	return 0

# Run once when the state is finished
func on_end(): 
	pass


