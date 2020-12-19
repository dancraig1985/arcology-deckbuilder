class_name Deck
extends Node2D

var DeckStackMachine

var is_acting: bool = false

export var is_facedown: bool = true
export var card_scale_in_deck_spot: float = 1.0
export var card_scale_in_card_spots: float = 1.0

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
	DeckStackMachine = Constants.STACK_MACHINE.new(self, Constants.ST_CARD_IDLE)

func _process(delta) -> void:
	DeckStackMachine.process(delta)

func get_screen_position() -> Vector2:
	return position + get_parent().position

func set_is_facedown(value: bool = true) -> void:
	is_facedown = value
	# TODO: more handling of flipping

func set_is_active(value: bool) -> void:
	is_acting = value

func get_is_acting() -> bool:
	return is_acting

func set_card_scale_in_deck_spot(value: float = 1.0) -> void:
	card_scale_in_deck_spot = value

func set_card_scale_in_card_spots(value: float = 1.0) -> void:
	card_scale_in_deck_spot = value

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

func is_empty() -> bool:
	return get_cards_count() < 1

func draw_card():
	var card_drawn = get_card_by_index(get_cards_top_index())
	remove_card(card_drawn)
	card_drawn.set_is_facedown(false)
	card_drawn.set_z_index(z_index + 10000)
	return card_drawn

func draw_cards_to_deck(num_cards: int, target_deck: Node) -> void:
	for i in range(num_cards):
		add_state(Constants.ST_DECK_DRAW_TO_DECK, {target_deck = target_deck})

func get_card_by_index(index: int) -> Card:
	return get_cards()[index]

func get_card_spots() -> Array:
	return node_card_spots.get_children()

func get_card_spots_count() -> int:
	return get_card_spots().size()

func get_card_spot_position(card_spot: Node) -> Vector2:
	return card_spot.position + card_spot.get_parent().position

func get_deck_spot_position() -> Vector2:
	return node_deck_spot.position

func refresh_card_positions() -> void:
	var card_spots = get_card_spots()
	var cards = get_cards()
	for i in range(get_cards_count()):
		var card = cards[i]
		card.set_z_index(i)
		if i < get_card_spots_count():
			var card_spot = card_spots[i]
			card.set_card_scale(card_scale_in_card_spots)
			card.move_to_position(get_card_spot_position(card_spot))
			card.set_is_facedown(is_facedown)
		else:
			var spot_position = get_deck_spot_position()
			var stacking_offset = Vector2(-i * 2, -i * 2)
			var target_position = spot_position + stacking_offset
			card.set_card_scale(card_scale_in_deck_spot)
			card.move_to_position(target_position)
			card.set_is_facedown(is_facedown)


func push_state(state_class: Script, new_args: Dictionary = {}) -> void:
	DeckStackMachine.push(state_class, new_args)

func add_state(state_class: Script, new_args: Dictionary = {}) -> void:
	DeckStackMachine.add(state_class, new_args)
