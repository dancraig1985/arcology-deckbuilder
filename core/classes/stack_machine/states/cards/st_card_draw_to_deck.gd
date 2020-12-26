extends StackMachineState

# host = Entity using the state
# args = arguments provided for state
# state_time = time in seconds we have been in this state
# state_env = {} < - Use to store info local to state

# Have process return 1 or -1 when the state is finished,
# otherwise return 0 to continue

func _init() -> void:
	name = "Card - Idle"

# Run once when the state starts
func on_start(): 
	host.is_acting = true
	host.set_z_index(Constants.OP_CARD_SHUFFLE_Z)
	var deck: Deck = host.deck
	var node_draw_display_spot: Node2D = deck.node_draw_display_spot
	var target_position: Vector2 = node_draw_display_spot.position
	state_env.target_position = target_position
	var target_scale: float = deck.draw_display_spot_scale
	var node_tween = host.node_card_tween
	
	state_env.node_tween = node_tween
	state_env.node_tween.interpolate_property(host, "position", 
			host.position, target_position, Constants.OP_CARD_MOVE_SPEED, 
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	state_env.node_tween.interpolate_property(host, "scale", 
			host.scale, target_scale, Constants.OP_CARD_MOVE_SPEED, 
			Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	state_env.node_tween.start()
	Audio.play("DealingCard")

# Usually called each step of the host, but can be called to run whenever
func process(delta): 
	var tween = state_env.node_tween
	if not tween.is_active() and state_time > Constants.OP_DECK_DRAW_DISPLAY_DELAY:
		return 1
	
	return 0

# Run once when the state is finished
func on_end(): 
	var current_deck: Deck = host.deck
	var target_deck: Deck = args.target_deck
	var to_index: int = args.to_index
	current_deck.remove_card(host)
	target_deck.add_card(host, to_index)
	host.emit_signal("card_effect_activated")
	


