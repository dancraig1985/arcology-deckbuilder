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
	var player_deck: Node = host.node_player_deck
	var player_deck_size: int = player_deck.get_cards_count()
	var player_hand: Node = host.node_player_hand
	var player_discard_deck: Node = host.node_player_discard_deck
	var num_cards_to_draw: int = Constants.BASE_CARD_DRAW_PER_TURN
	var num_cards_short: int
	if num_cards_to_draw > player_deck_size:
		num_cards_short = num_cards_to_draw - player_deck_size
		num_cards_to_draw = player_deck_size
		print_debug("Cards to Draw: " + str(num_cards_to_draw) + " - Base: " + str(Constants.BASE_CARD_DRAW_PER_TURN))
		print_debug("Cards in player_deck: " + str(player_deck_size))
		print_debug("Cards short: " + str(num_cards_short))
		# Dealer board actions are "pushed" not "added
		host.draw_cards_from_deck_to_deck(num_cards_short, player_deck, player_hand)
		
		## NEW STATE -> RESHUFFLE_DISCARD - I think it's finally 
		## unique enough to get own state
		host.shuffle_deck(player_deck)
		host.draw_cards_from_deck_to_deck(-1, player_discard_deck, player_deck)
		
		## NEW STATE -> DRAW_PHASE - Can repeat if needed after reshuffles, etc.
		host.draw_cards_from_deck_to_deck(num_cards_to_draw, player_deck, player_hand)
		
	else:
		host.draw_cards_from_deck_to_deck(num_cards_to_draw, player_deck, player_hand)

# Usually called each step of the host, but can be called to run whenever
func process(delta): ## < -- TODO: Move most of this input stuff to new State
	if state_time > Constants.OP_DEALER_BOARD_ACTION_DELAY:
		# we can use events from button presses
		# to set variables in Dealer that Dealer States will 
		# watch and handle. Handler must reset variable to "".
		if host.control_clicked == "Progress Turn":
			print_debug("Progress Turn button pressed")
			host.control_clicked = ""
			host.add_state(Constants.ST_DEALER_TURN_END)
			return 1
		if Input.is_action_just_pressed("ui_accept"):
			print_debug("Accept pressed")
			var resource_key = "Crypto"
			var resource = host.get_player_resource(resource_key)
			host.set_player_resource(resource_key, resource + 1)
			Audio.play("EarningMoney")
		if Input.is_action_just_pressed("ui_cancel"):
			print_debug("Cancel pressed")
			var player_discard_deck = host.node_player_discard_deck
			var player_hand = host.node_player_hand
			if not player_hand.is_empty():
				host.draw_cards_from_deck_to_deck(1, player_hand, player_discard_deck)
		if Input.is_action_just_pressed("ui_select"):
			print_debug("Select pressed")
			host.add_state(Constants.ST_DEALER_TURN_END)
			return 1
	return 0

# Run once when the state is finished
func on_end(): 
	pass


