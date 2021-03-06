extends StackMachineState

# host = Entity using the state
# args = arguments provided for state
# state_time = time in seconds we have been in this state

# Have process return 1 or -1 when the state is finished,
# otherwise return 0 to continue

func _init() -> void:
	name = "Dealer - Turn End"

# Run once when the state starts
func on_start():
	var player_name: String = host.human_player_name
	var player_hand: Node = host.node_player_hand
	var player_discard_deck: Node = host.node_player_discard_deck
	var player_hand_size = player_hand.get_cards_count()
	
	host.set_player_resource(player_name, "Crypto", 0)
	host.set_player_resource(player_name, "Guns", 0)
	host.set_player_resource(player_name, "Tech", 0)
	host.set_player_resource(player_name, "Ninja", 0)
	
	host.draw_cards_from_deck_to_deck(player_hand, player_discard_deck, player_hand_size, -1, -1)

# Usually called each step of the host, but can be called to run whenever
func process(delta): 
	if state_time > Constants.OP_END_OF_TURN_DELAY:
		host.add_turn_state(Constants.ST_DEALER_TURN_START)
		return 1
	return 0

# Run once when the state is finished
func on_end(): 
	pass


