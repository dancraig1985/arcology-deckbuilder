extends StackMachineState

# host = Entity using the state
# args = arguments provided for state
# state_time = time in seconds we have been in this state

# Have process return 1 or -1 when the state is finished,
# otherwise return 0 to continue

func _init() -> void:
	name = "Awaiting input..."

# Run once when the state starts
func on_start():
	pass

# Usually called each step of the host, but can be called to run whenever
func process(delta): ## < -- TODO: Move most of this input stuff to new State
	var dealer: Node = host
	var player_name = dealer.human_player_name
	var highlighted_card = dealer.get_card_highlight_mouse_selection()
	dealer.set_all_highlight_targets(false)
	dealer.highlight_all_affordable_targets(player_name)
	if state_time > Constants.OP_DEALER_BOARD_ACTION_DELAY:
		# we can use events from button presses
		# to set variables in Dealer that Dealer States will 
		# watch and handle. Handler must reset variable to "".
		if dealer.control_clicked == "Progress Turn" \
				or Input.is_action_just_pressed("ui_select"):
			print_debug("Progress Turn pressed")
			dealer.control_clicked = ""
			dealer.add_turn_state(Constants.ST_DEALER_TURN_END)
			return 1
		
		if Input.is_action_just_pressed("ui_accept") and highlighted_card:
			var market_hand: Node = dealer.node_market_hand
			var player_discard_deck: Node = dealer.node_player_discard_deck
			var card_cost = highlighted_card.get_card_cost()
			if dealer.get_player_can_afford_cost(player_name, card_cost):
				dealer.set_player_resources_minus_cost(player_name, card_cost)
				dealer.draw_node_to_deck(market_hand, 
											player_discard_deck, 
											highlighted_card)
				print_debug("Purchased " + highlighted_card.get_card_data_value("Card Name"))
	return 0

# Run once when the state is finished
func on_end(): 
	host.set_all_highlight_targets(false)


