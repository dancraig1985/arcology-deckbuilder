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
	new_card.get_parent().remove_child(new_card)
	node_cards.add_child(new_card)

func remove_card(card_to_remove: Node) -> void:
	node_cards.remove_child(card_to_remove)

func find_open_card_spot() -> int:
	return 0
