class_name CardLibrary
extends Node

var cards := {
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

func get_card_data(card_name: String) -> Dictionary:
	return cards[card_name]


