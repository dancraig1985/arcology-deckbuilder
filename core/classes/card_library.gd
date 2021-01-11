class_name CardLibrary
extends Node

var card_icons = [ # and order they should appear in array/match
	"Heart",
	"Crypto",
	"Guns",
	"Ninja",
	"Tech",
	"Draw",
]

var decks := {
	"Player Deck": {
		"Market Stall": 5, 
		"Rain": 6,
		"Cousin Jim": 1,
		"Net cultist": 2,
	},
	"Market Deck": {
		"Anarchist": 4,
		"Arcology Prime": 1,
		"Cat Burglar": 4,
		"Console Cowboy": 4,
		"Data Fence": 2,
		"Fixer": 2,
		"Hitman": 4,
		"Inner Spark": 4,
		"Jazz Dive": 4,
		"Local Muscle": 4,
		"LTA Veteran": 1,
		"Market Stall": 4,
		"Shadow Accountant": 2,
		"Small-time Fixer": 2,
		"Viper Biker Gang": 1,
	}
}
func load_cards() -> Dictionary:
# Card template
	# "Template": {
		# "Card Name": "Name of Card",
		# "Card Cost": {
			# "Crypto": 1,
			# ... other costs go in here
			# must be valid resource name (found in player Resources obj)
			# ie. no Draw cost or Heart cost (for now)
		# },
		# "Card Art": "File name for card-art (.png assumed)",
		# "Card Text": "Card description.",
		# "Card Scene": "card_grey.tscn",
		# "Card Icons": [  # Card Icon strings are evaluated at:
			# "Crypto",    # card - add_card_icon
			# "Heart"      # turn_state - evaluate drawn card
		# ],
		# "Effects": {}
	# }
	var cards_file := File.new()
	cards_file.open("res://assets/cards.json", File.READ)
	var cards_json := JSON.parse(cards_file.get_as_text())
	cards_file.close()
	return cards_json.result

var cards := load_cards()

func get_card_data(card_name: String) -> Dictionary:
	return cards[card_name]

func get_deck_list(deck_name: String) -> Dictionary:
	return decks[deck_name]
