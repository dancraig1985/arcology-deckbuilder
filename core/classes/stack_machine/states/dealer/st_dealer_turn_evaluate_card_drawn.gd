extends StackMachineState

# host = Entity using the state
# args = arguments provided for state
# state_time = time in seconds we have been in this state

# Have process return 1 or -1 when the state is finished,
# otherwise return 0 to continue

func _init() -> void:
	name = "Evaluating Drawn Card..."

# Run once when the state starts
func on_start():
	var card_drawn = args.card_drawn
	
	var player_name = host.human_player_name
	var resource_increment = 1
	
	var card_icons = card_drawn.get_card_data_value("Card Icons")
	for card_icon in card_icons:
		match card_icon:
			"Crypto":
				var prev_value = host.get_player_resource(player_name, card_icon)
				host.set_player_resource(player_name, 
											card_icon, 
											prev_value + resource_increment)
			"Heart":
				pass
			"Guns":
				var prev_value = host.get_player_resource(player_name, card_icon)
				host.set_player_resource(player_name, 
											card_icon, 
											prev_value + resource_increment)
			"Tech":
				var prev_value = host.get_player_resource(player_name, card_icon)
				host.set_player_resource(player_name, 
											card_icon, 
											prev_value + resource_increment)
			"Ninja":
				var prev_value = host.get_player_resource(player_name, card_icon)
				host.set_player_resource(player_name, 
											card_icon, 
											prev_value + resource_increment)
			"Draw":
				host.attempt_draw(host.node_player_deck, host.node_player_hand)

# Usually called each step of the host, but can be called to run whenever
func process(delta): ## < -- TODO: Move most of this input stuff to new State
	if state_time > Constants.OP_DEALER_BOARD_ACTION_DELAY:
		return 1
	return 0

# Run once when the state is finished
func on_end(): 
	pass


