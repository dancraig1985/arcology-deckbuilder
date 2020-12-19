extends Node

# Time it takes to complete a Card Move Tween in seconds
var OP_CARD_MOVE_SPEED = 0.4
# Time in seconds between card draws on Decks
var OP_DECK_DRAW_DELAY = 0.12
# Time in seconds between card spawns from Dealer
var OP_DEALER_SPAWN_DELAY = 0.06
# End of Turn Delay in seconds
var OP_END_OF_TURN_DELAY: float = 1.0
# Minimum time per Dealer action in seconds
var OP_DEALER_BOARD_ACTION_DELAY: float = 0.5

# BALANCE
var BASE_CARD_DRAW_PER_TURN: int = 5

const NODE_GROUPS = {
	DEALERS = "DEALERS",
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

const ST_DEALER_IDLE: Script = \
		preload("res://core/classes/stack_machine/states/dealer/st_dealer_idle.gd")
const ST_DEALER_SPAWN_CARDS_TO_DECK: Script = \
		preload("res://core/classes/stack_machine/states/dealer/st_dealer_spawn_cards_to_deck.gd")
const ST_DEALER_DRAW_CARDS_DECK_TO_DECK: Script = \
		preload("res://core/classes/stack_machine/states/dealer/st_dealer_draw_cards_deck_to_deck.gd")
const ST_DEALER_GAME_START: Script = \
		preload("res://core/classes/stack_machine/states/dealer/st_dealer_game_start.gd")
const ST_DEALER_TURN_START: Script = \
		preload("res://core/classes/stack_machine/states/dealer/st_dealer_turn_start.gd")
const ST_DEALER_TURN_END: Script = \
		preload("res://core/classes/stack_machine/states/dealer/st_dealer_turn_end.gd")
