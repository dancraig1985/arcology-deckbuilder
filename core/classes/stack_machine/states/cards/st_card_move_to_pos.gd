extends StackMachineState

# host = Entity using the state
# args = arguments provided for state
# state_time = time in seconds we have been in this state

# Have process return 1 or -1 when the state is finished,
# otherwise return 0 to continue

func _init() -> void:
	name = "Card - Move to Position"

# Run once when the state starts
func on_start():
	print_debug("card starting move at pos: " + str(host.position))
	var target_position = args.target_position
	var node_tween = host.node_card_tween
	state_env.node_tween = node_tween
	node_tween.stop_all()
	state_env.node_tween.interpolate_property(host, "position", 
			host.position, target_position, Constants.OP_CARD_MOVE_SPEED, 
			Tween.TRANS_QUART, Tween.EASE_IN_OUT)
	state_env.node_tween.start()

# Usually called each step of the host, but can be called to run whenever
func process(delta):
	if not state_env.node_tween.is_active():
		Audio.play("FlippingCard")
		return 1
	return 0

# Run once when the state is finished
func on_end(): 
	pass

