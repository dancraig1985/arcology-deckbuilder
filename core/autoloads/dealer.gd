extends Node

var DealerCardLibrary := CardLibrary.new()

var is_board_set_up := false

var card_highlight_mouse_candidates := []

var CardScene := preload("res://core/scenes/card.tscn")

onready var main_node = get_tree().get_root().get_node("Main")

func _ready():
	pass


func _process(delta):
	process_card_highlight_mouse()
	
	if not is_board_set_up:
		instance_card("Arcology Prime", Vector2(10, 10))
		
		instance_card("Arcology Prime", Vector2(10, 300), 5)
		instance_card("Console Cowboy", Vector2(30, 300), 4)
		instance_card("Arcology Prime", Vector2(50, 300), 3)
		instance_card("Console Cowboy", Vector2(70, 300), 2)

		instance_card("Console Cowboy", Vector2(10, 560))
		instance_card("Arcology Prime", Vector2(30, 820))
		instance_card("Console Cowboy", Vector2(50, 1080))
		
		is_board_set_up = true


func instance_card(card_name: String = "Template", \
						spawn_position: Vector2 = Vector2(0, 0), \
						spawn_z_index: int = 0) -> Node:
	var card_node = CardScene.instance()
	var card_data = DealerCardLibrary.get_card_data(card_name)
	main_node.add_child(card_node)
	#card_node.position = spawn_position
	card_node.push_state(Constants.ST_CARD_MOVE_TO_POSITION, {target_position = spawn_position})
	card_node.z_index = spawn_z_index
	card_node.import_card_data_from_dict(card_data)
	return card_node


func add_card_highlight_mouse_candidate(card: Node) -> void:
	card_highlight_mouse_candidates.append(card)

func remove_card_highlight_mouse_candidate(card: Node) -> void:
	var found_index = card_highlight_mouse_candidates.find(card)
	while found_index != -1:
		card_highlight_mouse_candidates.remove(found_index)
		found_index = card_highlight_mouse_candidates.find(card)
	
	card.set_highlight_mouse_visible(false)

func get_card_highlight_mouse_selection():
	#find highest z-index node
	var highest: int = -9999999
	var selection: Node
	for candidate in card_highlight_mouse_candidates:
		if candidate.z_index > highest:
			selection = candidate
			highest = candidate.z_index
	return selection

func process_card_highlight_mouse() -> void:
	if card_highlight_mouse_candidates.size() > 0:
		for candidate in card_highlight_mouse_candidates:
			candidate.set_highlight_mouse_visible(false)
		var card_to_highlight_mouse: Node = get_card_highlight_mouse_selection()
		card_to_highlight_mouse.set_highlight_mouse_visible(true)
