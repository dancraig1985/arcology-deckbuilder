extends Node2D

var card_highlight_mouse_candidates := []

var DealerCardLibrary := CardLibrary.new()

var CardScene := preload("res://core/scenes/card.tscn")

var is_board_set_up := false

onready var node_player_deck := $Decks/PlayerDeck
onready var node_player_hand := $Decks/PlayerHand


func _ready():
	pass

func _process(delta):
	process_card_highlight_mouse()
	
	if not is_board_set_up:
		spawn_card_to_deck("Arcology Prime", node_player_hand)
		spawn_card_to_deck("Console Cowboy", node_player_hand)
		spawn_card_to_deck("Arcology Prime", node_player_hand)
		spawn_card_to_deck("Arcology Prime", node_player_hand)
		spawn_card_to_deck("Arcology Prime", node_player_hand)
		spawn_card_to_deck("Arcology Prime", node_player_hand)
		spawn_card_to_deck("Console Cowboy", node_player_hand)
		spawn_card_to_deck("Arcology Prime", node_player_hand)
		spawn_card_to_deck("Arcology Prime", node_player_hand)
		spawn_card_to_deck("Arcology Prime", node_player_hand)

		spawn_card_to_deck("Arcology Prime", node_player_deck)
		spawn_card_to_deck("Console Cowboy", node_player_deck)
		spawn_card_to_deck("Arcology Prime", node_player_deck)
		spawn_card_to_deck("Arcology Prime", node_player_deck)
		spawn_card_to_deck("Arcology Prime", node_player_deck)
		spawn_card_to_deck("Arcology Prime", node_player_deck)
		spawn_card_to_deck("Console Cowboy", node_player_deck)
		spawn_card_to_deck("Arcology Prime", node_player_deck)
		spawn_card_to_deck("Arcology Prime", node_player_deck)
		spawn_card_to_deck("Arcology Prime", node_player_deck)
		spawn_card_to_deck("Arcology Prime", node_player_deck)
		spawn_card_to_deck("Console Cowboy", node_player_deck)
		spawn_card_to_deck("Arcology Prime", node_player_deck)
		spawn_card_to_deck("Arcology Prime", node_player_deck)
		spawn_card_to_deck("Arcology Prime", node_player_deck)
		spawn_card_to_deck("Arcology Prime", node_player_deck)
		spawn_card_to_deck("Console Cowboy", node_player_deck)
		spawn_card_to_deck("Arcology Prime", node_player_deck)
		spawn_card_to_deck("Arcology Prime", node_player_deck)
		spawn_card_to_deck("Arcology Prime", node_player_deck)
		
		is_board_set_up = true


func instance_card(card_name: String = "Template") -> Node:
	var card_node = CardScene.instance()
	var card_data = DealerCardLibrary.get_card_data(card_name)
	add_child(card_node) # add to tree to trigger _ready()
	card_node.import_card_data_from_dict(card_data)
	card_node.node_dealer = self
	Audio.play("EarningMoney")
	return card_node


func spawn_card_to_deck(card_name: String, target_deck: Deck) -> void:
	var card_node = instance_card(card_name)
	card_node.get_parent().remove_child(card_node)
	card_node.position = $SpawnSpot.position
	target_deck.add_card(card_node)


func add_card_highlight_mouse_candidate(candidate_card: Node) -> void:
	card_highlight_mouse_candidates.append(candidate_card)

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
