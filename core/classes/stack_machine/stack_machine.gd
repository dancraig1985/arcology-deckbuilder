extends Node

signal state_time_changed(new_value)
signal stack_machine_changed()

var host: Node
# Entity that the stateStack is attached to

var stack_machine: Array = []
# This member array is the heart of the whole operation.
# It looks like this:
# [[state_object1, [arg1, arg2, ...]], [state_object2, [arg1, arg2, ...]], ...]

var default_state
# a place to store a fallback state
# stored as a script resource reference
# default state does not accept args for now (might fix in future)

func _init(new_host: Node, new_default_state: Script):
	host = new_host
	default_state = new_default_state
	add_create(default_state)

func process(delta):
	# Method for processing the current state @ pos 0
	if stack_machine.size() > 0:
		# get top state info
		var state_object = stack_machine[0][0]
		var state_args = stack_machine[0][1]
		
		# Check for first time running, and start state
		if state_object.state_time == 0:
			state_object.on_start(state_args)
			state_object.started = true
			
		# state.process returns 0 to repeat
		# Pop the stack if return 1, process right away if -1
		var proceed = state_object.process(delta, state_args)
		
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
		push_create(default_state)
		process(delta) # and try to run it right away

func push(state):
	# add a state to front of state stack
	stack_machine.push_front(state)
	emit_signal("stack_machine_changed")

func add(state):
	# add a state to end of state stack
	stack_machine.append(state)
	emit_signal("stack_machine_changed")

func push_create(state_class, args = []):
	# create and add a state class with args to front of state stack
	push(state_create(state_class, args))

func add_create(state_class, args = []):
	# create and add a state class and args to end of state stack
	add(state_create(state_class, args))

func pop():
	# pop from state stack
	var top_state = stack_machine.pop_front()
	var state_object = top_state[0]
	var state_args = top_state[1]
	# process on_end event for the popped state
	state_object.on_end(state_args)
	emit_signal("stack_machine_changed")

func state_create(state_class, args = []):
	# creates an entry appropriate for the stack_machine array
	# [state_ref, [arg1, arg2, ...]]
	var state_object = state_class.new()
	state_object.host = host
	
	var state = [state_object, args]
	return state

func is_stack_machine_empty() -> bool:
	return not stack_machine.size() > 0

func get_current_state():
	if not is_stack_machine_empty():
		return stack_machine[0]

func get_current_state_obj():
	if not is_stack_machine_empty():
		return get_state_obj(get_current_state())

func get_current_state_args():
	if not is_stack_machine_empty():
		return get_state_args(get_current_state())

func get_current_state_name():
	if not is_stack_machine_empty():
		return get_state_name(get_current_state())

func get_state_obj(state) -> Object:
	return state[0]

func get_state_args(state) -> Array:
	return state[1]

func get_state_name(state) -> String:
	return get_state_obj(state).name

