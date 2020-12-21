extends StackMachineState

# host = Entity using the state
# args = arguments provided for state
# state_time = time in seconds we have been in this state

# Have process return 1 or -1 when the state is finished,
# otherwise return 0 to continue

func _init() -> void:
	name = "Awaiting input..."

# Run once when the state starts
func on_start():
	pass

# Usually called each step of the host, but can be called to run whenever
func process(delta): ## < -- TODO: Move most of this input stuff to new State
	var player_name = host.human_player_name
	host.set_all_highlight_targets(false)
	host.highlight_all_affordable_targets(player_name)
	if state_time > Constants.OP_DEALER_BOARD_ACTION_DELAY:
		# we can use events from button presses
		# to set variables in Dealer that Dealer States will 
		# watch and handle. Handler must reset variable to "".
		if host.control_clicked == "Progress Turn" \
				or Input.is_action_just_pressed("ui_select"):
			print_debug("Progress Turn pressed")
			host.control_clicked = ""
			host.add_turn_state(Constants.ST_DEALER_TURN_END)
			return 1
	return 0

# Run once when the state is finished
func on_end(): 
	host.set_all_highlight_targets(false)


