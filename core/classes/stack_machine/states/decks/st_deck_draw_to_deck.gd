extends StackMachineState

# host = Entity using the state
# args = arguments provided for state
# state_time = time in seconds we have been in this state

# Have process return 1 or -1 when the state is finished,
# otherwise return 0 to continue

func _init() -> void:
	name = "Deck - Draw Card to Deck"

# Run once when the state starts
func on_start():
	host.set_is_acting(true)
	state_env.is_card_drawn = false	

# Usually called each step of the host, but can be called to run whenever
func process(delta):
	# If set to keep trying to draw a card until we get one
	if host.is_empty():
		if host.is_wait_for_refill_on_empty:
			return 0
		else:
			return 1
	
	if not state_env.is_card_drawn:
		var drawn_card = host.draw_card()
		args.target_deck.add_card(drawn_card)
		host.set_is_acting(true)
		state_env.is_card_drawn = true
		state_time = 0
		Audio.play("DealingCard")
	
	var draw_delay = Constants.OP_DECK_DRAW_DELAY
	if state_time > draw_delay and state_env.is_card_drawn:
		return 1
	return 0

# Run once when the state is finished
func on_end(): 
	pass

