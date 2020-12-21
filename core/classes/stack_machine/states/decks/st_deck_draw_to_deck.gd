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
	var host_is_empty = host.is_empty()
	if host_is_empty and host.is_auto_refilled:
		# stuck here forever now :(
		return 0
	else:
		if host_is_empty:
			return 1
	
	if not state_env.is_card_drawn:
		state_env.is_card_drawn = true
		var target_deck = args.target_deck
		var drawn_card = host.draw_card() # TODO: add args to this for index top/bottom
		target_deck.add_card(drawn_card)
		Audio.play("DealingCard")
	
	var draw_delay = Constants.OP_DECK_DRAW_DELAY
	if state_time > draw_delay and state_env.is_card_drawn:
		return 1
	return 0

# Run once when the state is finished
func on_end(): 
	pass

