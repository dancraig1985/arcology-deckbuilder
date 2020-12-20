extends Node2D

var card_highlight_mouse_candidates := []

var DealerCardLibrary := CardLibrary.new()

var DealerStackMachine

var CardScene := preload("res://core/scenes/card.tscn")

var is_board_set_up := false
var is_acting: bool = false

onready var node_player_deck := $Decks/PlayerDeck
onready var node_player_hand := $Decks/PlayerHand
onready var node_player_discard_deck := $Decks/PlayerDiscardDeck


func _ready():
	add_to_group(Constants.NODE_GROUPS.DEALERS)
	DealerStackMachine = Constants.STACK_MACHINE.new(self, Constants.ST_DEALER_IDLE)
	add_state(Constants.ST_DEALER_GAME_START)

func _process(delta):
	process_card_highlight_mouse()
	DealerStackMachine.process(delta)

func get_is_any_actor_acting() -> bool:
	var actors_acting: bool = false
	for card in get_tree().get_nodes_in_group(Constants.NODE_GROUPS.CARDS):
		actors_acting = card.is_acting
	for deck in get_tree().get_nodes_in_group(Constants.NODE_GROUPS.DECKS):
		actors_acting = deck.is_acting
	return actors_acting

func instance_card(card_name: String = "Template") -> Node:
	var card_node = CardScene.instance()
	var card_data = DealerCardLibrary.get_card_data(card_name)
	add_child(card_node) # add to tree to trigger _ready()
	remove_child(card_node)
	card_node.import_card_data_from_dict(card_data)
	card_node.node_dealer = self
	return card_node

func spawn_cards_to_deck(card_name: String, num_cards: int, target_deck: Deck) -> void:
	for i in range(num_cards):
		#push_state(Constants.ST_DEALER_WAIT_FOR_ACTING)
		push_state(Constants.ST_DEALER_SPAWN_CARDS_TO_DECK, {
			card_name = card_name,
			num_cards = 1,
			target_deck = target_deck
		})

func draw_cards_from_deck_to_deck(num_cards: int, 
									source_deck: Node, 
									target_deck: Node) -> void:
	push_state(Constants.ST_DEALER_WAIT_FOR_ACTING)
	push_state(Constants.ST_DEALER_DRAW_CARDS_DECK_TO_DECK, {
		num_cards = num_cards,
		source_deck = source_deck,
		target_deck = target_deck
	})

func shuffle_deck(target_deck: Deck) -> void:
	push_state(Constants.ST_DEALER_WAIT_FOR_ACTING)
	push_state(Constants.ST_DEALER_SHUFFLE_DECK, {
		target_deck = target_deck
	})

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


func push_state(state_class: Script, new_args: Dictionary = {}) -> void:
	DealerStackMachine.push(state_class, new_args)

func add_state(state_class: Script, new_args: Dictionary = {}) -> void:
	DealerStackMachine.add(state_class, new_args)

func set_is_acting(value: bool) -> void:
	is_acting = value

func get_is_acting() -> bool:
	return is_acting
