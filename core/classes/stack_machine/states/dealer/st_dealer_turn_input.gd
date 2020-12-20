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
	if state_time > Constants.OP_DEALER_BOARD_ACTION_DELAY:
		# we can use events from button presses
		# to set variables in Dealer that Dealer States will 
		# watch and handle. Handler must reset variable to "".
		if host.control_clicked == "Progress Turn" \
				or Input.is_action_just_pressed("ui_select"):
			print_debug("Progress Turn pressed")
			host.control_clicked = ""
			host.add_turn_state(Constants.ST_DEALER_TURN_END)
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
	return 0

# Run once when the state is finished
func on_end(): 
	pass


