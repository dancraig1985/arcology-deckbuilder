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
	var player_hand: Node = host.node_player_hand
	
	for i in range(Constants.BASE_CARD_DRAW_PER_TURN):
		host.attempt_draw(player_deck, player_hand)
	
	var market_deck: Node = host.node_market_deck
	var market_hand: Node = host.node_market_hand
	
	host.shuffle_deck(market_deck)
	
	for i in range(Constants.BASE_MARKET_DISCARD_PER_TURN):
		host.attempt_draw(market_hand, market_deck)
	
	for i in range(Constants.BASE_MARKET_CARD_DRAW_PER_TURN):
		host.attempt_draw(market_deck, market_hand)

# Usually called each step of the host, but can be called to run whenever
func process(delta): ## < -- TODO: Move most of this input stuff to new State
	if state_time > Constants.OP_DEALER_BOARD_ACTION_DELAY:
		host.add_turn_state(Constants.ST_DEALER_TURN_INPUT)
		return 1
	return 0

# Run once when the state is finished
func on_end(): 
	pass


