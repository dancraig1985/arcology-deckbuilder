class_name Deck
extends Node2D

export var deck_list: Dictionary = {
	"Arcology Prime": 14,
	"Console Cowboy": 6
}
export var deck_name: String = "Player Deck"

onready var node_deck_spot := $DeckSpot
onready var node_card_spots := $CardSpots
onready var node_cards := $Cards


func _ready() -> void:
	pass

func get_screen_position() -> Vector2:
	return position + get_parent().position

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

func is_empty() -> bool:
	return get_cards_count() > 0

func move_card_to_deck(move_card: Node, target_deck: Node) -> void:
	if is_empty(): return

func move_card_at_index_to_deck(card_index: int, target_deck: Node):
	if is_empty(): return

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
			card.move_to_position(get_card_spot_position(card_spot))
			card.set_is_facedown(false)
		else:
			card.move_to_position(get_deck_spot_position())
			card.set_is_facedown(true)
	
	
