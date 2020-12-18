extends Node

signal state_time_changed(new_value)
signal stack_machine_changed()

var host: Node
# Entity that the stateStack is attached to

var stack_machine: Array = []
# This member array is the heart of the whole operation.
# It looks like this:
# [[state_object1, [arg1, arg2, ...]], [state_object2, [arg1, arg2, ...]], ...]

var default_state: Script
# a place to store a fallback state
# stored as a script resource reference
# default state does not accept args for now (might fix in future)

func _init(new_host: Node, new_default_state: Script):
	host = new_host
	default_state = new_default_state
	push(default_state)

func process(delta):
	# Method for processing the current state @ pos 0
	if stack_machine.size() > 0:
		# get top state info
		var state_object = stack_machine[0]
		var state_args = state_object.args
		
		# Check for first time running, and start state
		if state_object.state_time == 0:
			state_object.on_start()
			state_object.started = true
			
		# state.process returns 0 to repeat
		# Pop the stack if return 1, process right away if -1
		var proceed = state_object.process(delta)
		
		# increment state_time by delta
		state_object.state_time += delta
		emit_signal("state_time_changed", state_object.state_time)
		
		# handle finished states
		if proceed == 1 or proceed == -1:
			pop()
			if proceed == -1:
				process(delta)
	elif default_state != null:
		# If state stack is empty, we push the default
		push(default_state)
		process(delta) # and try to run it right away

func push(state_class: Script, args: Dictionary = {}) -> void:
	# add a state to front of state stack
	stack_machine.push_front(state_create(state_class, args))
	emit_signal("stack_machine_changed")

func add(state_class: Script, args: Dictionary = {}) ->void:
	# add a state to end of state stack
	stack_machine.append(state_create(state_class, args))
	emit_signal("stack_machine_changed")

func pop():
	# pop from state stack
	var state_object = stack_machine.pop_front()
	# process on_end event for the popped state
	state_object.on_end()
	emit_signal("stack_machine_changed")

func state_create(state_class, args = {}):
	# creates a new state object ready to be pushed to stack machine
	var state = state_class.new()
	state.host = host
	state.args = args
	return state

func is_stack_machine_empty() -> bool:
	return not stack_machine.size() > 0

func get_current_state():
	if not is_stack_machine_empty():
		return stack_machine[0]

func get_current_state_args():
	if not is_stack_machine_empty():
		return get_state_args(get_current_state())

func get_current_state_name():
	if not is_stack_machine_empty():
		return get_state_name(get_current_state())

func get_state_args(state) -> Array:
	return state.args

func get_state_name(state) -> String:
	return state.name

