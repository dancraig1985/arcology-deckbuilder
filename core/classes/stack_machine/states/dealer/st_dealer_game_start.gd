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
	var player_deck_card_list = host.DealerCardLibrary.get_deck_list("Player Deck")
	var market_deck_card_list = host.DealerCardLibrary.get_deck_list("Market Deck")
	var player_deck = host.node_player_deck
	var market_deck = host.node_market_deck
	var market_hand = host.node_market_hand
	
	host.shuffle_deck(player_deck)
	host.spawn_cards_to_deck(player_deck_card_list, player_deck)
	
	for i in range(Constants.BASE_MARKET_CARD_DRAW_GAME_START):
		host.attempt_draw(market_deck, market_hand)
	
	host.shuffle_deck(market_deck)
	host.spawn_cards_to_deck(market_deck_card_list, market_deck)

# Usually called each step of the host, but can be called to run whenever
func process(delta): 
	if state_time > Constants.OP_DEALER_BOARD_ACTION_DELAY:
		host.add_turn_state(Constants.ST_DEALER_TURN_START)
		return 1
	return 0

# Run once when the state is finished
func on_end(): 
	pass


