extends Node2D

var card_highlight_mouse_candidates := []

var DealerCardLibrary := CardLibrary.new()

var CardScene := preload("res://core/scenes/card.tscn")

var is_board_set_up := false

onready var node_player_deck := $Decks/PlayerDeck
onready var node_player_hand := $Decks/PlayerHand
onready var node_player_discard_deck := $Decks/PlayerDiscardDeck


func _ready():
	pass

func _process(delta):
	process_card_highlight_mouse()
	
	if Input.is_action_just_pressed("ui_accept"):
		print_debug("Accept pressed")
		if not node_player_deck.is_empty():
			draw_cards_from_deck_to_deck(1, node_player_deck, node_player_hand)
	
	if Input.is_action_just_pressed("ui_cancel"):
		print_debug("Cancel pressed")
		if not node_player_hand.is_empty():
			draw_cards_from_deck_to_deck(1, node_player_hand, node_player_discard_deck)
	
	if not is_board_set_up:
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

func draw_cards_from_deck_to_deck(num_cards: int, 
									source_deck: Node, 
									target_deck: Node) -> void:
	var cards_to_draw = min(source_deck.get_cards_count(), num_cards)
	source_deck.draw_cards_to_deck(cards_to_draw, target_deck)


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
