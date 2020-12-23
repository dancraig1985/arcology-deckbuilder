extends StackMachineState

# host = Entity using the state
# args = arguments provided for state
# state_time = time in seconds we have been in this state

# Have process return 1 or -1 when the state is finished,
# otherwise return 0 to continue

func _init() -> void:
	name = "Dealer - Spawn Cards"

# Run once when the state starts
func on_start():
	# Spawn card from card name and add to target Deck
	var card_node = host.instance_card(args.card_name)
	card_node.position = host.get_node("SpawnSpot").position
	args.target_deck.add_card(card_node, -1)
	Audio.play("EarningMoney")

# Usually called each step of the host, but can be called to run whenever
func process(delta):
	var draw_delay = Constants.OP_DEALER_SPAWN_DELAY
	if state_time > draw_delay:
		return 1
	return 0

# Run once when the state is finished
func on_end(): 
	pass
