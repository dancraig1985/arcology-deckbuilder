class_name Deck
extends Node2D

var DeckStackMachine

var is_acting: bool = false

var card_spots_start: int = 0
var card_spots_end: int # derived from start and card_count

export var is_facedown: bool = true
export var is_wait_for_refill_on_empty: bool = false

export var deck_list: Dictionary = {
	"Arcology Prime": 14,
	"Console Cowboy": 6
}
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

func set_deck_list(new_deck_list: Dictionary) -> void:
	deck_list = new_deck_list

func add_card(new_card: Node) -> void:
	node_cards.add_child(new_card) # FIX: this is at pos(0,0)
	refresh_card_positions()

func remove_card(card_to_remove: Node) -> void:
	node_cards.remove_child(card_to_remove)
	refresh_card_positions()

func get_cards() -> Array:
	return node_cards.get_children()

func get_cards_count() -> int:
	return get_cards().size()

func get_cards_top_index() -> int:
	return get_cards().size() - 1

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

func draw_card():
	var card_drawn = get_card_by_index(get_cards_top_index())
	remove_card(card_drawn)
	card_drawn.set_is_facedown(false)
	return card_drawn

func draw_cards_to_deck(num_cards: int, target_deck: Node) -> void:
	for i in range(num_cards):
		add_state(Constants.ST_DECK_DRAW_TO_DECK, {target_deck = target_deck})

func shuffle() -> void:
	add_state(Constants.ST_DECK_SHUFFLE)

func add_refresh_card_positions() -> void:
	add_state(Constants.ST_DECK_REFRESH_CARD_POSITIONS)

func refresh_card_positions() -> void:
	var card_spots = get_card_spots()
	var card_spots_count = get_card_spots_count()
	var cards = get_cards()
	var cards_count = get_cards_count()
	for i in range(cards_count):
		var card = cards[i]
		card.set_z_index(i)
		if i < card_spots_count:
			var card_spot = card_spots[i]
			var target_scale = Vector2(Constants.OP_CARD_IN_HAND_SCALE, 
										Constants.OP_CARD_IN_HAND_SCALE)
			card.move_to_position(get_card_spot_position(card_spot), target_scale)
			card.set_is_facedown(is_facedown)
		else:
			var spot_position = get_deck_spot_position()
			var stacking_offset = Vector2(-i * 2, -i * 2)
			var target_position = spot_position + stacking_offset
			var target_scale = Vector2(Constants.OP_CARD_DECK_SCALE, 
										Constants.OP_CARD_DECK_SCALE)
			card.move_to_position(target_position, target_scale)
			card.set_is_facedown(is_facedown)

func get_card_by_index(index: int) -> Card:
	return get_cards()[index]

func get_card_spots() -> Array:
	return node_card_spots.get_children()

func get_card_spots_count() -> int:
	return get_card_spots().size()

func set_card_spots_start(start_i: int = 0) -> void:
	var cards_count: int = get_cards_count()
	var by_one_offset: int = -1
	card_spots_start = min(start_i, cards_count + by_one_offset)

func get_card_spots_start() -> int:
	return card_spots_start

func get_card_spots_end(cards_spot_start: int) -> int:
	var card_spots_count = get_card_spots_count()
	var cards_count = get_cards_count()
	card_spots_end = card_spots_start + card_spots_count - 1
	if card_spots_end >= cards_count:
		card_spots_end = card_spots_end - cards_count
	return card_spots_end

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
