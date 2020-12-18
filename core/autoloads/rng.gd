extends Node

func _ready():
	randomize()

# Returns random int between max and min, default 0 - 9
func get_randi(max_val: int = 10, min_val: int = 0) -> int:
	return randi() % max_val + min_val

func value_from_list(_array):
	return _array[randi() % _array.size()]
