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
	host.is_acting = true
	
	var target_position = args.target_position
	var target_scale = args.target_scale
	var node_tween = host.node_card_tween
	state_env.node_tween = node_tween
	node_tween.remove_all()
	state_env.node_tween.interpolate_property(host, "position", 
			host.position, target_position, Constants.OP_CARD_MOVE_SPEED, 
			Tween.TRANS_QUART, Tween.EASE_IN_OUT)
	state_env.node_tween.interpolate_property(host, "scale", 
			host.scale, target_scale, Constants.OP_CARD_MOVE_SPEED, 
			Tween.TRANS_QUART, Tween.EASE_IN_OUT)
	state_env.node_tween.start()

# Usually called each step of the host, but can be called to run whenever
func process(delta):
	var tween = state_env.node_tween
	if not tween.is_active():
		tween.remove_all()
		return 1
	
	var distance_to_target = args.target_position - host.position
	if distance_to_target.length() < 1:
		return -1
	
	return 0

# Run once when the state is finished
func on_end():
	Audio.play("FlippingCard")

