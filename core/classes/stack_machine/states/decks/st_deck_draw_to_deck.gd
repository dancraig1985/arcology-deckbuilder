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
	if not host.is_empty():
		var drawn_card = host.draw_card()
		args.target_deck.add_card(drawn_card)
		Audio.play("DealingCard")

# Usually called each step of the host, but can be called to run whenever
func process(delta):
	if host.is_empty(): return 1
	var draw_delay = Constants.OP_DECK_DRAW_DELAY
	if state_time > draw_delay:
		return 1
	return 0

# Run once when the state is finished
func on_end(): 
	pass

