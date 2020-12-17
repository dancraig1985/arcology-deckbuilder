extends Node

var card_library := {
	"Template": {
		"Card Name": "Name of Card",
		"Card Art": "File name for card-art (.png assumed)",
		"Card Text": "Card description."
	},
	"Arcology Prime": {
		"Card Name": "Arcology Prime",
		"Card Art": "arcology",
		"Card Text": "This is the first card in the game."
	},
	"Console Cowboy": {
		"Card Name": "Console Cowboy",
		"Card Art": "console_cowboy",
		"Card Text": "Just a runner doin biz.\nGain one money."
	}
}

var is_board_set_up := false

var card_scene := preload("res://core/scenes/card.tscn")

onready var main_node = get_tree().get_root().get_node("Main")

func _ready():	
	pass

func instance_card(card_name: String = "Template", spawn_position: Vector2 = Vector2(0, 0)) -> Card:
	var card_node = card_scene.instance()
	main_node.add_child(card_node)
	card_node.position = spawn_position
	card_node.setup_from_library(card_name)
	return card_node

func _process(delta):
	if not is_board_set_up:
		instance_card("Arcology Prime", Vector2(10, 10))
		instance_card("Console Cowboy", Vector2(200, 10))
		instance_card("Arcology Prime", Vector2(10, 300))
		is_board_set_up = true
