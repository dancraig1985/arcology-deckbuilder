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
	var player_hand: Node = host.node_player_hand
	
	var card_drawn = source_deck.draw_card()
	target_deck.add_card(card_drawn)
	if target_deck == player_hand:
		host.evaluate_card_drawn(card_drawn)

# Usually called each step of the host, but can be called to run whenever
func process(delta): ## < -- TODO: Move most of this input stuff to new State
	if state_time > Constants.OP_DEALER_BOARD_ACTION_DELAY:
		return 1
	return 0

# Run once when the state is finished
func on_end(): 
	pass


