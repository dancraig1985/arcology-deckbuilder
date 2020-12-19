extends Node

# Time it takes to complete a Card Move Tween in seconds
var OP_CARD_MOVE_SPEED = 0.5

# Time in seconds between card draws on Decks
var OP_DECK_DRAW_DELAY = 0.25

const NODE_GROUPS = {
	CARDS = "CARDS",
	DECKS = "DECKS"
}


const STACK_MACHINE_PATH: String = "res://core/classes/stack_machine/stack_machine.gd"
const STACK_MACHINE: Script = preload(STACK_MACHINE_PATH)

const ST_TEMPLATE: Script = \
		preload("res://core/classes/stack_machine/states/st_template.gd")

const ST_CARD_IDLE: Script = \
		preload("res://core/classes/stack_machine/states/cards/st_card_idle.gd")
const ST_CARD_MOVE_TO_POSITION: Script = \
		preload("res://core/classes/stack_machine/states/cards/st_card_move_to_pos.gd")

const ST_DECK_IDLE: Script = \
		preload("res://core/classes/stack_machine/states/decks/st_deck_idle.gd")
const ST_DECK_DRAW_TO_DECK: Script = \
		preload("res://core/classes/stack_machine/states/decks/st_deck_draw_to_deck.gd")

