extends StackMachineState

# host = Entity using the state
# args = arguments provided for state
# state_time = time in seconds we have been in this state

# Have process return 1 or -1 when the state is finished,
# otherwise return 0 to continue

func _init() -> void:
	name = "Turn Start"

# Run once when the state starts
func on_start():
	var player_deck: Node = host.node_player_deck
	var player_deck_size: int = player_deck.get_cards_count()
	var player_hand: Node = host.node_player_hand
	var num_cards_to_draw: int = Constants.BASE_CARD_DRAW_PER_TURN
	var num_cards_short: int = num_cards_to_draw - player_deck_size
	print_debug("Cards to Draw: " + str(num_cards_to_draw) + " - Base: " + str(Constants.BASE_CARD_DRAW_PER_TURN))
	print_debug("Cards in player_deck: " + str(player_deck_size))
	print_debug("Cards short: " + str(num_cards_short))
	
	for i in range(num_cards_to_draw):
		host.attempt_draw(player_deck, player_hand)

# Usually called each step of the host, but can be called to run whenever
func process(delta): ## < -- TODO: Move most of this input stuff to new State
	if state_time > Constants.OP_DEALER_BOARD_ACTION_DELAY:
		host.add_turn_state(Constants.ST_DEALER_TURN_INPUT)
		return 1
	return 0

# Run once when the state is finished
func on_end(): 
	pass


