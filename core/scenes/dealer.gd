extends Node2D

signal player_data_updated()

var card_highlight_mouse_candidates := []

var mouse_scroll_reload: float = 0.0
var is_mouse_scrollable: bool = false
var scroll_deck: Deck
var DealerCardLibrary := CardLibrary.new()

var DealerStackMachine

var CardScene := preload("res://core/scenes/card.tscn")

var control_clicked: String = ""

var human_player_name: String = "Reefpirate"
var player_data = {
	human_player_name: {
		"Name": human_player_name,
		"Resources": {
			"Crypto": 0,
			"Guns": 0,
			"Tech": 0,
			"Ninja": 0
		}
	},
	"Player Two": {
		"Name": "Player Two",
		"Resources": {
			"Crypto": 0,
			"Guns": 0,
			"Tech": 0,
			"Ninja": 0
		}
	},
}

onready var node_player_deck := $Decks/PlayerDeck
onready var node_player_hand := $Decks/PlayerHand
onready var node_player_discard_deck := $Decks/PlayerDiscardDeck
onready var node_market_deck := $Decks/MarketDeck
onready var node_market_hand := $Decks/MarketHand

onready var node_turn_status_label:= $TurnPanel/StatusPanel/TurnStatusLabel
onready var node_crypto_label:= $TurnPanel/ResourceHBox/CryptoCounter/Center/HBox/ResourceLabel
onready var node_guns_label:= $TurnPanel/ResourceHBox/GunsCounter/Center/HBox/ResourceLabel
onready var node_tech_label:= $TurnPanel/ResourceHBox/TechCounter/Center/HBox/ResourceLabel
onready var node_ninja_label:= $TurnPanel/ResourceHBox/NinjaCounter/Center/HBox/ResourceLabel

onready var node_progress_turn_button := $TurnPanel/ProgressTurnButton

func _ready():
	add_to_group(Constants.NODE_GROUPS.DEALERS)
	
	DealerStackMachine = Constants.STACK_MACHINE.new(self, Constants.ST_DEALER_IDLE)
	add_state(Constants.ST_DEALER_GAME_START)
	
	connect("player_data_updated", self, "_on_player_data_updated")
	node_progress_turn_button.connect("pressed", self, "_on_progress_turn_button_pressed")
	
	refresh_player_labels()

func _process(delta):
	process_card_highlight_mouse()
	
	if not is_mouse_scrollable:
		mouse_scroll_reload += delta
	if mouse_scroll_reload > Constants.OP_MOUSE_SCROLL_DELAY:
		mouse_scroll_reload = 0
		is_mouse_scrollable = true
	
	if card_highlight_mouse_candidates.size() > 0:
		scroll_deck = get_card_highlight_mouse_selection().deck
	else:
		scroll_deck = node_player_deck
	
	node_turn_status_label.text = DealerStackMachine.get_current_state_name()
	DealerStackMachine.process(delta)
	
	# Global (not game state dependent) Controls go here
	if scroll_deck.get_cards_count() > scroll_deck.get_card_spots_count():
		if Input.is_action_just_released("ui_scroll_up") and is_mouse_scrollable:
			is_mouse_scrollable = false
			var scroll_increment: int = -1
			scroll_deck.increment_card_spots_start(scroll_increment)
		
		if Input.is_action_just_released("ui_scroll_down") and is_mouse_scrollable:
			is_mouse_scrollable = false
			var scroll_increment: int = 1
			scroll_deck.increment_card_spots_start(scroll_increment)

func get_is_any_actor_acting() -> bool:
	var actors_acting: bool = false
	for card in get_tree().get_nodes_in_group(Constants.NODE_GROUPS.CARDS):
		actors_acting = card.is_acting
	for deck in get_tree().get_nodes_in_group(Constants.NODE_GROUPS.DECKS):
		actors_acting = deck.is_acting
	return actors_acting

func instance_card(card_name: String = "Template") -> Card:
	var card_data = DealerCardLibrary.get_card_data(card_name)
	var card_scene = load("res://core/scenes/cards/" + card_data["Card Scene"])
	var card_node = card_scene.instance()
	add_child(card_node) # add to tree to trigger _ready()
	remove_child(card_node)
	card_node.import_card_data_from_dict(card_data)
	card_node.node_dealer = self
	return card_node

func spawn_cards_to_deck(card_list: Dictionary, target_deck: Deck) -> void:
	push_state(Constants.ST_DEALER_WAIT_FOR_ACTING)
	for key in card_list.keys():
		var card_name = key
		var num_cards = card_list[card_name]
		for i in range(num_cards):
			push_state(Constants.ST_DEALER_SPAWN_CARDS_TO_DECK, {
				card_name = card_name,
				num_cards = 1,
				target_deck = target_deck
			})
		

func get_all_cards() -> Array:
	return get_tree().get_nodes_in_group(Constants.NODE_GROUPS.CARDS)

func draw_cards_from_deck_to_deck(
									source_deck: Node, 
									target_deck: Node,
									num_cards: int = 0, # -1 = all) -> void:
									from_index: int = -1, # -1 = bottom
									to_index: int = 0
								) -> void: 
	push_state(Constants.ST_DEALER_WAIT_FOR_ACTING)
	push_state(Constants.ST_DEALER_DRAW_CARDS_DECK_TO_DECK, {
		source_deck = source_deck,
		target_deck = target_deck,
		num_cards = num_cards,
		from_index = from_index,
		to_index = to_index
	})

func draw_to_deck(source_deck: Node,
					target_deck: Node,
					from_index: int = -1,
					to_index: int = 0) -> void:
	push_state(Constants.ST_DEALER_WAIT_FOR_ACTING)
	push_state(Constants.ST_DEALER_TURN_DRAW_CARD, {
		source_deck = source_deck,
		target_deck = target_deck,
		from_index = from_index,
		to_index = to_index
	})

func attempt_draw(source_deck: Node,
					target_deck: Node,
					from_index: int = -1,
					to_index: int = 0) -> void:
	push_state(Constants.ST_DEALER_WAIT_FOR_ACTING)
	push_state(Constants.ST_DEALER_TURN_ATTEMPT_DRAW, {
		source_deck = source_deck,
		target_deck = target_deck,
		from_index = from_index,
		to_index = to_index
	})

func reshuffle_discard() -> void:
	push_state(Constants.ST_DEALER_WAIT_FOR_ACTING)
	push_state(Constants.ST_DEALER_TURN_RESHUFFLE_DISCARD)

func evaluate_card_drawn(card_drawn: Node) -> void:
	push_state(Constants.ST_DEALER_WAIT_FOR_ACTING)
	push_state(Constants.ST_DEALER_TURN_EVALUATE_CARD_DRAWN, {
		card_drawn = card_drawn
	})

func shuffle_deck(target_deck: Deck) -> void:
	push_state(Constants.ST_DEALER_WAIT_FOR_ACTING)
	push_state(Constants.ST_DEALER_SHUFFLE_DECK, {
		target_deck = target_deck
	})

func add_turn_state(state_class: Script) -> void:
	add_state(state_class)
	add_state(Constants.ST_DEALER_WAIT_FOR_ACTING)

func set_player_data(player_name: String, new_data: Dictionary = {}) -> void:
	player_data[player_name] = new_data
	emit_signal("player_data_updated")

func get_player_data(player_name: String) -> Dictionary:
	return player_data[player_name]

func get_player_data_value(player_name: String, key: String):
	return get_player_data(player_name)[key]

func set_player_resource(player_name: String, key: String, new_value: int) -> void:
	var temp_player_data: Dictionary = get_player_data(player_name)
	temp_player_data["Resources"][key] = new_value
	set_player_data(player_name, temp_player_data)

func get_player_resource(player_name: String, key: String):
	return get_player_data(player_name)["Resources"][key]

func get_player_resources(player_name: String) -> Dictionary:
	return get_player_data_value(player_name, "Resources")

func get_player_can_afford_cost(player_name: String, target_cost: Dictionary) -> bool:
	var can_afford = true
	var resources = get_player_resources(player_name)
	for cost_key in target_cost.keys():
		if resources[cost_key] < target_cost[cost_key]:
			can_afford = false
	return can_afford

func add_card_highlight_mouse_candidate(candidate_card: Node) -> void:
	card_highlight_mouse_candidates.append(candidate_card)

func remove_card_highlight_mouse_candidate(card: Node) -> void:
	var found_index = card_highlight_mouse_candidates.find(card)
	while found_index != -1:
		card_highlight_mouse_candidates.remove(found_index)
		found_index = card_highlight_mouse_candidates.find(card)
	card.set_highlight_mouse_visible(false)

func get_card_highlight_mouse_selection() -> Card:
	#find highest z-index node
	var highest: int = -9999999
	var selection: Card
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

func set_all_highlight_targets(value: bool) -> void:
	for card in get_all_cards():
		card.set_highlight_target_visible(value)

func highlight_all_affordable_targets(player_name: String) -> void:
	for card in get_all_cards():
		var card_cost = card.get_card_cost()
		if get_player_can_afford_cost(player_name, card_cost) \
				and not card.get_is_facedown() \
				and card.get_is_for_sale_to_player():
			card.set_highlight_target_visible(true)

func _on_progress_turn_button_pressed() -> void:
	control_clicked = "Progress Turn" 

func _on_player_data_updated():
	refresh_player_labels()

func refresh_player_labels() -> void:
	node_crypto_label.text = str(get_player_resource(human_player_name, "Crypto"))
	node_guns_label.text = str(get_player_resource(human_player_name, "Guns"))
	node_tech_label.text = str(get_player_resource(human_player_name, "Tech"))
	node_ninja_label.text = str(get_player_resource(human_player_name, "Ninja"))

func push_state(state_class: Script, new_args: Dictionary = {}) -> void:
	DealerStackMachine.push(state_class, new_args)

func add_state(state_class: Script, new_args: Dictionary = {}) -> void:
	DealerStackMachine.add(state_class, new_args)

