extends StackMachineState

# host = Entity using the state
# args = arguments provided for state
# state_time = time in seconds we have been in this state

# Have process return 1 or -1 when the state is finished,
# otherwise return 0 to continue

func _init() -> void:
	name = "Dealer - Draw Cards Deck-to-Deck"

# Run once when the state starts
func on_start():
	var num_cards = args.num_cards # -1 to draw whole deck
	var source_deck = args.source_deck
	var target_deck = args.target_deck
	var from_index = args.from_index
	var to_index = args.to_index
	
	if num_cards == -1: # draw all
		num_cards = source_deck.get_cards_count()
	
	source_deck.draw_cards_to_deck(target_deck, num_cards, from_index, to_index)

# Usually called each step of the host, but can be called to run whenever
func process(delta):
	if state_time > Constants.OP_DEALER_BOARD_ACTION_DELAY:
		return 1
	return 0

# Run once when the state is finished
func on_end(): 
	pass
