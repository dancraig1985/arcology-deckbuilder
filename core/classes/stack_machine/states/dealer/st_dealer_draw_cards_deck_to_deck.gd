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
	host.set_is_acting(true)
	
	var num_cards = args.num_cards # -1 to draw whole deck
	var source_deck = args.source_deck
	var target_deck = args.target_deck
	
	if num_cards == -1:
		num_cards = source_deck.get_cards_count()
	
	source_deck.draw_cards_to_deck(num_cards, target_deck)

# Usually called each step of the host, but can be called to run whenever
func process(delta):
	if state_time > Constants.OP_DEALER_BOARD_ACTION_DELAY:
		return 1
	return 0

# Run once when the state is finished
func on_end(): 
	pass
