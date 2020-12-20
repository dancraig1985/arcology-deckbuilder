extends StackMachineState

# host = Entity using the state
# args = arguments provided for state
# state_time = time in seconds we have been in this state

# Have process return 1 or -1 when the state is finished,
# otherwise return 0 to continue

func _init() -> void:
	name = "Deck - Refresh Card Positions"

# Run once when the state starts
func on_start(): 
	host.set_is_acting(true)
	
	var card_spots = host.get_card_spots()
	var card_spots_count = host.get_card_spots_count()
	var cards = host.get_cards()
	var cards_count = host.get_cards_count()
	var is_facedown = host.get_is_facedown()
	for i in range(cards_count):
		var card = cards[i]
		card.set_z_index(i)
		if i < card_spots_count:
			var card_spot = card_spots[i]
			var target_position = host.get_card_spot_position(card_spot)
			var target_scale = Vector2(Constants.OP_CARD_IN_HAND_SCALE, 
										Constants.OP_CARD_IN_HAND_SCALE)
			card.move_to_position(target_position, target_scale)
			card.set_is_facedown(is_facedown)
		else:
			var spot_position = host.get_deck_spot_position()
			var stacking_offset = Vector2(-i * 2, -i * 2)
			var target_position = spot_position + stacking_offset
			var target_scale = Vector2(Constants.OP_CARD_DECK_SCALE, 
										Constants.OP_CARD_DECK_SCALE)
			card.move_to_position(target_position, target_scale)
			card.set_is_facedown(is_facedown)

# Usually called each step of the host, but can be called to run whenever
func process(delta): 
	if not host.is_at_least_one_card_acting() and state_time > Constants.OP_DECK_BOARD_ACTION_DELAY:
		return 1
	return 0

# Run once when the state is finished
func on_end(): 
	pass


