class_name Deck
extends Node2D

export var deck_list: Dictionary = {
	"Arcology Prime": 14,
	"Console Cowboy": 6
}
export var deck_name: String = "Player Deck"

onready var node_card_spots: Node = $CardSpots
onready var node_cards: Node = $Cards


func _ready() -> void:
	pass

func set_deck_list(new_deck_list: Dictionary) -> void:
	deck_list = new_deck_list

func add_card(new_card: Node) -> void:
	node_cards.add_child(new_card) # FIX: this is at pos(0,0)
	refresh_card_positions()

func remove_card(card_to_remove: Node) -> void:
	node_cards.remove_child(card_to_remove)

func refresh_card_positions() -> void:
	var card_spots = node_card_spots.get_children()
	var cards = node_cards.get_children()
	for i in range(cards.size()):
		var card = cards[i]
		card.z_index = i
		if i < card_spots.size():
			var card_spot = card_spots[i]
			card.add_state(Constants.ST_CARD_MOVE_TO_POSITION, {target_position = card_spot.position})
			card.set_is_facedown(false)
		else:
			card.add_state(Constants.ST_CARD_MOVE_TO_POSITION, {target_position = Vector2()})
			card.set_is_facedown(true)
	
	
