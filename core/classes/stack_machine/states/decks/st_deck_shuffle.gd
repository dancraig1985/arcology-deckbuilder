extends StackMachineState

# host = Entity using the state
# args = arguments provided for state
# state_time = time in seconds we have been in this state

# Have process return 1 or -1 when the state is finished,
# otherwise return 0 to continue

func _init() -> void:
	name = "Deck - Shuffle"

# Run once when the state starts
func on_start(): 
	host.set_is_acting(true)
	
	var target_deck = host
	var cards = target_deck.get_cards()
	var cards_parent = target_deck.get_cards_parent()
	for card in cards:
		cards_parent.remove_child(card)
	
	cards.shuffle()
	Audio.play("ShufflingCards")
	
	for card in cards:
		cards_parent.add_child(card)
	
	for card in cards:
		card.set_z_index(Constants.OP_CARD_SHUFFLE_Z)
		var rand_x = card.position.x + RNG.get_randi(75, -75)
		var rand_y = card.position.y + RNG.get_randi(120, -120)
		
		var rand_pos = host.position + Vector2(rand_x, rand_y)
		var shuffle_scale = Vector2(Constants.OP_CARD_SHUFFLE_SCALE,
									Constants.OP_CARD_SHUFFLE_SCALE)
		card.move_to_position(rand_pos, shuffle_scale)

# Usually called each step of the host, but can be called to run whenever
func process(delta): 
	if not host.is_at_least_one_card_acting() and state_time > Constants.OP_DECK_BOARD_ACTION_DELAY:
		host.add_refresh_card_positions()
		return 1
	return 0

# Run once when the state is finished
func on_end(): 
	pass


