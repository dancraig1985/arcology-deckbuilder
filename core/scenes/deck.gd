class_name Deck
extends Node2D


var DeckStackMachine

var is_acting: bool = false


# card spots are a group of 2d coordinates that designate where the visible
# cards in the deck will be placed on screen
#
# to facilitate scrolling through a deck of cards with limited visible cards
# on screen, we maintain an Array of card_indexes in linear sequence to be used 
# when placing cards on the screen

var card_spots_start: int = 0 # card_index in deck where card_spots start
var card_spot_indexes: Array = [] # array of card indexes per card spot

enum DECK_STYLE {
	CARD_PILE,
	CARD_DISPLAY
}

export var deck_style: int = DECK_STYLE.CARD_PILE

export var is_facedown: bool = true
export var is_for_sale_to_player: bool = false
export var is_auto_refilled: bool = false # <- set true to cancel draw orders on decks
											#  otherwise deck will keep trying to draw

export var deck_name: String = "Player Deck"

onready var node_deck_spot := $DeckSpot
onready var node_card_spots := $CardSpots
onready var node_cards := $Cards


func _ready() -> void:
	add_to_group(Constants.NODE_GROUPS.DECKS)
	DeckStackMachine = Constants.STACK_MACHINE.new(self, Constants.ST_DECK_IDLE)

func _process(delta) -> void:
	DeckStackMachine.process(delta)

func get_screen_position() -> Vector2:
	return position + get_parent().position

func set_is_facedown(value: bool = true) -> void:
	is_facedown = value
	# TODO: more handling of flipping

func get_is_facedown() -> bool:
	return is_facedown

func add_card(new_card: Node, to_index: int = 0) -> void:
	new_card.deck = self
	node_cards.add_child(new_card)
	var valid_to_index: int = get_valid_card_index(to_index)
	node_cards.move_child(new_card, valid_to_index)
	
	# the order of the following two methods is IMPORTANT
	# this is probably not good
	new_card.set_is_for_sale_to_player(is_for_sale_to_player)
	new_card.set_is_facedown(is_facedown)
	
	refresh_card_positions()

func remove_card(card_to_remove: Node) -> void:
	node_cards.remove_child(card_to_remove)
	refresh_card_positions()

func get_cards() -> Array:
	return node_cards.get_children()

func get_cards_count() -> int:
	return get_cards().size()

func get_cards_bottom_index() -> int:
	var cards_count = get_cards_count()
	if cards_count < 1:
		return 0
	return cards_count - 1

func get_cards_parent() -> Node:
	return node_cards

func is_empty() -> bool:
	return get_cards_count() < 1

func is_at_least_one_card_acting() -> bool:
	var card_is_acting: bool = false
	for card in get_cards():
		if card.is_acting:
			card_is_acting = true
	return card_is_acting

func draw_card(index: int) -> Card:
	var deck_bottom_index = get_cards_bottom_index()
	var valid_card_index: int = get_valid_card_index(index)
	var card_drawn: Card = get_card_by_index(valid_card_index)
	node_cards.remove_child(card_drawn)
	Audio.play("DealingCard")
	return card_drawn

func get_valid_card_index(index: int) -> int:
	var deck_bottom_index = get_cards_bottom_index()
	if index < 0 or index > deck_bottom_index:
		return deck_bottom_index
	return index

func draw_cards_to_deck(target_deck: Node,
						num_cards: int = 1,
						from_index: int = -1,
						to_index: int = 0) -> void:
	# card_index is not guaranteed position to draw from
	# dependent on how many cards are in deck
	# reliable bet is top of the deck (card_index = 0)
	for i in range(num_cards):
		add_state(Constants.ST_DECK_DRAW_TO_DECK, {
				target_deck = target_deck,
				num_cards = num_cards,
				from_index = from_index,
				to_index = to_index
			})

func draw_card_to_deck(target_deck: Node,
						from_index: int = -1,
						to_index: int = 0) -> Card:
	var card_drawn = draw_card(from_index)
	target_deck.add_card(card_drawn, to_index)
	return card_drawn

func draw_card_node_to_deck(target_deck: Deck, target_card: Card):
	remove_card(target_card)
	target_deck.add_card(target_card, -1)
	refresh_card_positions()

func shuffle() -> void:
	add_state(Constants.ST_DECK_SHUFFLE)

func add_refresh_card_positions() -> void:
	add_state(Constants.ST_DECK_REFRESH_CARD_POSITIONS)

func refresh_card_positions() -> void:
	var cards = get_cards()
	var cards_count = get_cards_count()
	if cards_count < 1:
		return
	
	var target_position: Vector2
	var target_scale: Vector2
	
	refresh_card_spot_indexes()
	
	var card_spots_count: int = get_card_spots_count()
	var card_spots_counted: int = 0
	var cards_in_deck: int = 0
	for i in range(cards_count):
		var card: Card = cards[i]
		if card_spot_indexes.size() > 0 \
				and card_spots_count > 0 \
				and card_spots_counted < card_spots_count \
				and card_spot_indexes.has(i): # <- send to card_spots logic
					
			var card_spots_index: int = card_spot_indexes.find(i)
			card_spots_counted += 1
			var card_spot = get_card_spots()[card_spots_index]
			card.set_z_index(Constants.OP_CARD_IN_HAND_Z)
			target_position = get_card_spot_position(card_spot)
			target_scale = Vector2(Constants.OP_CARD_IN_HAND_SCALE, 
										Constants.OP_CARD_IN_HAND_SCALE)
			card.move_to_position(target_position, target_scale)
		else: # <- send to deck
			card.set_z_index(Constants.OP_CARD_DECK_Z + cards_in_deck)
			cards_in_deck += 1
			var spot_position = get_deck_spot_position()
			var stacking_offset = Vector2(-cards_in_deck * 1, -cards_in_deck * 1)
			
			target_position = spot_position + stacking_offset
			target_scale = Vector2(Constants.OP_CARD_DECK_SCALE, 
										Constants.OP_CARD_DECK_SCALE)
			card.move_to_position(target_position, target_scale)

func get_card_by_index(index: int) -> Card:
	return get_cards()[index]

func get_card_spots() -> Array:
	return node_card_spots.get_children()

func get_card_spots_count() -> int:
	return get_card_spots().size()

func get_card_spots_start() -> int:
	return card_spots_start

func get_card_spots_end(cards_spot_start: int) -> int:
	var card_spots_count = get_card_spots_count()
	var cards_count = get_cards_count()
	var card_spots_end = card_spots_start + card_spots_count - 1
	if card_spots_end >= cards_count:
		card_spots_end = card_spots_end - cards_count
	return card_spots_end

func refresh_card_spot_indexes() -> void:
	card_spot_indexes.clear()
	var card_spots_count = get_card_spots_count()
	var cards_count = get_cards_count()
	if cards_count > 0:
		for i in range(card_spots_count):
			if i >= cards_count:
				break
			var card_index = card_spots_start + i
			if card_index >= cards_count:
				card_spot_indexes.append(card_index - cards_count)
			else:
				card_spot_indexes.append(card_index)
	if name == "PlayerHand":
		print_debug("Deck card spot indexes: " + str(card_spot_indexes))

func set_card_spots_start(start_i: int = 0) -> int:
	# will wrap around deck until index < card_count >= 0
	var cards_count: int = get_cards_count()
	if cards_count < 1:
		card_spots_start = 0
		return cards_count
	if start_i >= cards_count:
		while start_i >= cards_count:
			start_i -= cards_count
	if start_i < 0:
		while start_i < 0:
			start_i += cards_count
	card_spots_start = start_i
	refresh_card_positions()
	return card_spots_start

func increment_card_spots_start(value: int) -> int:
	return set_card_spots_start(get_card_spots_start() + value)

func get_card_spot_position(card_spot: Node) -> Vector2:
	return card_spot.position + card_spot.get_parent().position

func is_valid_card_spot_index(index: int) -> bool:
	var start_i = get_card_spots_start()
	return index >= start_i and index <= get_card_spots_end(start_i)

func get_deck_spot_position() -> Vector2:
	return node_deck_spot.position


# Private-ish functions
func push_state(state_class: Script, new_args: Dictionary = {}) -> void:
	DeckStackMachine.push(state_class, new_args)

func add_state(state_class: Script, new_args: Dictionary = {}) -> void:
	DeckStackMachine.add(state_class, new_args)

func set_is_acting(value: bool) -> void:
	is_acting = value

func get_is_acting() -> bool:
	return is_acting
