extends StackMachineState

# host = Entity using the state
# args = arguments provided for state
# state_time = time in seconds we have been in this state

# Have process return 1 or -1 when the state is finished,
# otherwise return 0 to continue

func _init() -> void:
	name = "Dealer - Turn Start"

# Run once when the state starts
func on_start():
	state_env.ending_turn = false
	
	var player_deck: Node = host.node_player_deck
	var player_deck_size: int = player_deck.get_cards_count()
	var player_hand: Node = host.node_player_hand
	var player_discard_deck: Node = host.node_player_discard_deck
	var num_cards_to_draw: int = Constants.BASE_CARD_DRAW_PER_TURN
	var num_cards_short: int
	if num_cards_to_draw > player_deck_size:
		num_cards_short = num_cards_to_draw - player_deck_size
		num_cards_to_draw = player_deck_size
		host.draw_cards_from_deck_to_deck(num_cards_to_draw, player_deck, player_hand)
		host.draw_cards_from_deck_to_deck(-1, player_discard_deck, player_deck)
		host.draw_cards_from_deck_to_deck(num_cards_short, player_deck, player_hand)
	else:
		host.draw_cards_from_deck_to_deck(num_cards_to_draw, player_deck, player_hand)

# Usually called each step of the host, but can be called to run whenever
func process(delta): 
	if not host.is_any_actor_acting():
		if Input.is_action_just_pressed("ui_accept"):
			print_debug("Accept pressed")
			var player_deck = host.node_player_deck
			var player_hand = host.node_player_hand
			if not player_deck.is_empty():
				host.draw_cards_from_deck_to_deck(1, player_deck, player_hand)
		
		if Input.is_action_just_pressed("ui_cancel"):
			print_debug("Cancel pressed")
			var player_discard_deck = host.node_player_discard_deck
			var player_hand = host.node_player_hand
			if not player_hand.is_empty():
				host.draw_cards_from_deck_to_deck(1, player_hand, player_discard_deck)
		
		if Input.is_action_just_pressed("ui_select") and state_env.ending_turn == false:
			print_debug("Select pressed")
			state_env.ending_turn = true
	if state_env.ending_turn == true and not host.is_any_actor_acting():
		if state_time > Constants.OP_END_OF_TURN_DELAY:
			host.add_state(Constants.ST_DEALER_TURN_END)
			return 1
	return 0

# Run once when the state is finished
func on_end(): 
	pass


