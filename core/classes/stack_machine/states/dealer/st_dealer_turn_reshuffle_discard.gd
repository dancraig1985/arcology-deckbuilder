extends StackMachineState

# host = Entity using the state
# args = arguments provided for state
# state_time = time in seconds we have been in this state

# Have process return 1 or -1 when the state is finished,
# otherwise return 0 to continue

func _init() -> void:
	name = "Reshuffling Discard Deck..."

# Run once when the state starts
func on_start():
	var player_deck: Node = host.node_player_deck
	var player_discard_deck: Node = host.node_player_discard_deck
	
	host.shuffle_deck(player_deck)
	host.draw_cards_from_deck_to_deck(player_discard_deck, player_deck, -1, -1, 0)

# Usually called each step of the host, but can be called to run whenever
func process(delta): ## < -- TODO: Move most of this input stuff to new State
	if state_time > Constants.OP_DEALER_BOARD_ACTION_DELAY:
		return 1
	return 0

# Run once when the state is finished
func on_end(): 
	pass


