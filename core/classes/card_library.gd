class_name CardLibrary
extends Node

var card_icons = [ # and order they should appear in array/match
	"Heart",
	"Crypto",
	"Guns",
	"Ninja",
	"Tech",
	"Draw"
]

var decks := {
	"Player Deck": {
		"Market Stall": 5, 
		"Rain": 6,
		"Cousin Jim": 1,
		"Viper Biker Gang": 2,
		"Anarchist": 4,
		"Inner Spark": 4,
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

var cards := { ## < -- TODO: Import this from JSON
	"Template": {
		"Card Name": "Name of Card",
		"Card Cost": {
			"Crypto": 1,
			# ... other costs go in here
			# must be valid resource name (found in player Resources obj)
			# ie. no Draw cost or Heart cost (for now)
		},
		"Card Art": "File name for card-art (.png assumed)",
		"Card Text": "Card description.",
		"Card Scene": "card_grey.tscn",
		"Card Icons": [  # Card Icon strings are evaluated at:
			"Crypto",    # card - add_card_icon
			"Heart"      # turn_state - evaluate drawn card
		],
		"Effects": {}
	},
	##########################################################
	## MARKET CARDS ##########################################
	"Anarchist": {
		"Card Name": "Anarchist",
		"Card Cost": {
			"Crypto": 3
		},
		"Card Art": "anarchist",
		"Card Text": "Morally flexible activist.",
		"Card Scene": "card_blue.tscn",
		"Card Icons": [
			"Heart",
			"Ninja"
		]
	},
	"Arcology Prime": {
		"Card Name": "Arcology Prime",
		"Card Cost": {
			"Crypto": 10
		},
		"Card Art": "arcology",
		"Card Text": "A city in a steel tower.",
		"Card Scene": "card_green.tscn",
		"Card Icons": [
			"Crypto",
			"Crypto",
			"Crypto",
			"Tech",
			"Draw"
		]
	},
	"Cat Burglar": {
		"Card Name": "Cat Burglar",
		"Card Cost": {
			"Crypto": 6
		},
		"Card Art": "art_thief",
		"Card Text": "No common criminal, he steals the rich stuff!",
		"Card Scene": "card_blue.tscn",
		"Card Icons": [
			"Ninja",
			"Ninja"
		]
	},
	"Console Cowboy": {
		"Card Name": "Console Cowboy",
		"Card Cost": {
			"Crypto": 5
		},
		"Card Art": "console_cowboy",
		"Card Text": "Risking his neck for the tech.",
		"Card Scene": "card_purple.tscn",
		"Card Icons": [
			"Heart",
			"Tech"
		]
	},
	"Cousin Jim": {
		"Card Name": "Cousin Jim",
		"Card Cost": {
			"Crypto": 0
		},
		"Card Art": "cousin_jim",
		"Card Text": "He's not much, but he's always been there for you.",
		"Card Scene": "card_red.tscn",
		"Card Icons": [
			"Health",
			"Guns"
		]
	},
	"Data Fence": {
		"Card Name": "Data Fence",
		"Card Cost": {
			"Crypto": 6
		},
		"Card Art": "data_fence",
		"Card Text": "You can get black market prices with the right info.",
		"Card Scene": "card_purple.tscn",
		"Card Icons": [
			"Crypto",
			"Crypto",
			"Tech"
		]
	},
	"Fixer": {
		"Card Name": "Fixer",
		"Card Cost": {
			"Crypto": 7
		},
		"Card Art": "fixer",
		"Card Text": "His office smells like crap but he knows people.",
		"Card Scene": "card_green.tscn",
		"Card Icons": [
			"Crypto",
			"Crypto",
			"Draw"
		]
	},
	"Hitman": {
		"Card Name": "Hitman",
		"Card Cost": {
			"Crypto": 6
		},
		"Card Art": "hitman",
		"Card Text": "Quantities of ammunition have a quality all their own.",
		"Card Scene": "card_red.tscn",
		"Card Icons": [
			"Heart",
			"Heart",
			"Guns",
			"Guns"
		]
	},
	"Inner Spark": {
		"Card Name": "Inner Spark",
		"Card Cost": {
			"Crypto": 3
		},
		"Card Art": "spark",
		"Card Text": "I have an idea!",
		"Card Scene": "card_green.tscn",
		"Card Icons": [
			"Crypto",
			"Draw"
		]
	},
	"Jazz Dive": {
		"Card Name": "Jazz Dive",
		"Card Cost": {
			"Crypto": 2
		},
		"Card Art": "jazz_dive",
		"Card Text": "Hard-boiled tequila and woodwinds.",
		"Card Scene": "card_green.tscn",
		"Card Icons": [
			"Draw"
		]
	},
	"Local Muscle": {
		"Card Name": "Local Muscle",
		"Card Cost": {
			"Crypto": 3
		},
		"Card Art": "local_muscle",
		"Card Text": "Cannon fodder good for collecting money.",
		"Card Scene": "card_red.tscn",
		"Card Icons": [
			"Heart",
			"Guns"
		]
	},
	"LTA Veteran": {
		"Card Name": "LTA Veteran",
		"Card Cost": {
			"Crypto": 8
		},
		"Card Art": "lta_veteran",
		"Card Text": "Survivor of the Glider War, now premium sprawl muscle.",
		"Card Scene": "card_red.tscn",
		"Card Icons": [
			"Heart",
			"Heart",
			"Guns",
			"Guns",
			"Guns",
			"Ninja"
		]
	},
	"Market Stall": {
		"Card Name": "Market Stall",
		"Card Cost": {
			"Crypto": 2
		},
		"Card Art": "market_stall",
		"Card Text": "Among the few remaining remnants of your legitimate previous life.",
		"Card Scene": "card_green.tscn",
		"Card Icons": [
			"Crypto"
		]
	},
	"Rain": {
		"Card Name": "Rain",
		"Card Cost": {
			"Crypto": 0
		},
		"Card Art": "rainy_day",
		"Card Text": "Maybe tomorrow...",
		"Card Scene": "card_grey.tscn",
		"Card Icons": [
		
		]
	},
	"Shadow Accountant": {
		"Card Name": "Shadow Accountant",
		"Card Cost": {
			"Crypto": 5
		},
		"Card Art": "shadow_accountant",
		"Card Text": "What they don't earn is made up by their savings.",
		"Card Scene": "card_green.tscn",
		"Card Icons": [
			"Crypto",
			"Crypto"
		]
	},
	"Small-time Fixer": {
		"Card Name": "Small-time Fixer",
		"Card Cost": {
			"Crypto": 4
		},
		"Card Art": "small_time_fixer",
		"Card Text": "An local hook-up who may have a lead on a few things.",
		"Card Scene": "card_green.tscn",
		"Card Icons": [
			"Crypto",
			"Crypto"
		]
	},
	"Viper Biker Gang": {
		"Card Name": "Viper Biker Gang",
		"Card Cost": {
			"Crypto": 6
		},
		"Card Art": "motorcycle_gang",
		"Card Text": "Guns on bikes go vroom.",
		"Card Scene": "card_red.tscn",
		"Card Icons": [
			"Heart",
			"Guns",
			"Draw"
		]
	}
}

func get_card_data(card_name: String) -> Dictionary:
	return cards[card_name]

func get_deck_list(deck_name: String) -> Dictionary:
	return decks[deck_name]
