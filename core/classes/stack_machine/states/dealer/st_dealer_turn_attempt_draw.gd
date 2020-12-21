extends StackMachineState

# host = Entity using the state
# args = arguments provided for state
# state_time = time in seconds we have been in this state

# Have process return 1 or -1 when the state is finished,
# otherwise return 0 to continue

func _init() -> void:
	name = "Drawing Card to Player Hand..."

# Run once when the state starts
func on_start():
	var source_deck: Node = args.source_deck
	var target_deck: Node = args.target_deck
	var player_deck: Node = host.node_player_deck
	# Player has special reshuffle() trick for now
	if source_deck.is_empty() and source_deck == player_deck:
		host.reshuffle_discard()
	if not source_deck.is_empty():
		host.draw_to_deck(source_deck, target_deck)

# Usually called each step of the host, but can be called to run whenever
func process(delta): ## < -- TODO: Move most of this input stuff to new State
	if state_time > Constants.OP_DEALER_BOARD_ACTION_DELAY:
		return 1
	return 0

# Run once when the state is finished
func on_end(): 
	pass


