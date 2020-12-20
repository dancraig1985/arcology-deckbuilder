class_name CardLibrary
extends Node

var cards := {
	"Template": {
		"Card Name": "Name of Card",
		"Card Art": "File name for card-art (.png assumed)",
		"Card Text": "Card description.",
		"Card Icons": [
			"Crypto",
			"Heart"
		],
		"Effects": {}
	},
	"Rainy Day": {
		"Card Name": "Rainy Day",
		"Card Art": "rainy_day",
		"Card Text": "Maybe tomorrow...",
		"Card Icons": [
		
		]
	},
	"Arcology Prime": {
		"Card Name": "Arcology Prime",
		"Card Art": "arcology",
		"Card Text": "Cyber money.",
		"Card Icons": [
			"Crypto"
		]
	},
	"Console Cowboy": {
		"Card Name": "Console Cowboy",
		"Card Art": "console_cowboy",
		"Card Text": "Risking his neck for tech.",
		"Card Icons": [
			"Heart",
			"Crypto",
			"Tech"
		]
	},
	"Viper Gang": {
		"Card Name": "Viper Gang",
		"Card Art": "motorcycle_gang",
		"Card Text": "Guns on bikes go vroom.",
		"Card Icons": [
			"Heart",
			"Guns"
		]
	}
}

var decks := {
	"Player Deck": {
		"Arcology Prime": 3,
		"Console Cowboy": 2
	}
}

func get_card_data(card_name: String) -> Dictionary:
	return cards[card_name]


