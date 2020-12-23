extends Node

# SPEEDS AND TIMINGS
# Delay before next mouse scroll wheel input
var OP_MOUSE_SCROLL_DELAY: float = 0.12
# Time it takes to complete a Card Move Tween in seconds
var OP_CARD_MOVE_SPEED = 0.2
# Time in seconds between card draws on Decks
var OP_DECK_DRAW_DELAY = 0.08
# Time in seconds between card spawns from Dealer
var OP_DEALER_SPAWN_DELAY = 0.01
# End of Turn Delay in seconds
var OP_END_OF_TURN_DELAY: float = 0.8
# Minimum time per Dealer action in seconds
var OP_DEALER_BOARD_ACTION_DELAY: float = 0.1
# Minimum time per Dealer action in seconds
var OP_DECK_BOARD_ACTION_DELAY: float = 0.1

# VISUAL CONSTANTS
var OP_CARD_SHUFFLE_SCALE: float = 1.0
var OP_CARD_DECK_SCALE: float = 0.6
var OP_CARD_IN_HAND_SCALE: float = 1.0


# BALANCE
var BASE_CARD_DRAW_PER_TURN: int = 4

var BASE_MARKET_CARD_DRAW_GAME_START: int = 1
var BASE_MARKET_CARD_DRAW_PER_TURN: int = 1
var BASE_MARKET_DISCARD_PER_TURN: int = 0

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
const ST_DECK_SHUFFLE: Script = \
		preload("res://core/classes/stack_machine/states/decks/st_deck_shuffle.gd")
const ST_DECK_REFRESH_CARD_POSITIONS: Script = \
		preload("res://core/classes/stack_machine/states/decks/st_deck_refresh_card_positions.gd")

# DEALER BOARD ACTIONS
const ST_DEALER_IDLE: Script = \
		preload("res://core/classes/stack_machine/states/dealer/st_dealer_idle.gd")
const ST_DEALER_WAIT_FOR_ACTING: Script = \
		preload("res://core/classes/stack_machine/states/dealer/st_dealer_wait_for_acting.gd")
const ST_DEALER_SPAWN_CARDS_TO_DECK: Script = \
		preload("res://core/classes/stack_machine/states/dealer/st_dealer_spawn_cards_to_deck.gd")
const ST_DEALER_DRAW_CARDS_DECK_TO_DECK: Script = \
		preload("res://core/classes/stack_machine/states/dealer/st_dealer_draw_cards_deck_to_deck.gd")
const ST_DEALER_SHUFFLE_DECK: Script = \
		preload("res://core/classes/stack_machine/states/dealer/st_dealer_shuffle_deck.gd")

# DEALER TURN PHASES
const ST_DEALER_GAME_START: Script = \
		preload("res://core/classes/stack_machine/states/dealer/st_dealer_game_start.gd")
const ST_DEALER_TURN_START: Script = \
		preload("res://core/classes/stack_machine/states/dealer/st_dealer_turn_start.gd")
const ST_DEALER_TURN_ATTEMPT_DRAW: Script = \
		preload("res://core/classes/stack_machine/states/dealer/st_dealer_turn_attempt_draw.gd")
const ST_DEALER_TURN_RESHUFFLE_DISCARD: Script = \
		preload("res://core/classes/stack_machine/states/dealer/st_dealer_turn_reshuffle_discard.gd")
const ST_DEALER_TURN_DRAW_CARD: Script = \
		preload("res://core/classes/stack_machine/states/dealer/st_dealer_turn_draw_card.gd")
const ST_DEALER_TURN_EVALUATE_CARD_DRAWN: Script = \
		preload("res://core/classes/stack_machine/states/dealer/st_dealer_turn_evaluate_card_drawn.gd")
const ST_DEALER_TURN_INPUT: Script = \
		preload("res://core/classes/stack_machine/states/dealer/st_dealer_turn_input.gd")
const ST_DEALER_TURN_END: Script = \
		preload("res://core/classes/stack_machine/states/dealer/st_dealer_turn_end.gd")


# Pre-loaded Scenes
const SC_ICON_HEART = preload("res://core/scenes/card_icons/icon_heart.tscn")
const SC_ICON_CRYPTO = preload("res://core/scenes/card_icons/icon_money.tscn")
const SC_ICON_GUNS = preload("res://core/scenes/card_icons/icon_gun.tscn")
const SC_ICON_TECH = preload("res://core/scenes/card_icons/icon_tech.tscn")
const SC_ICON_NINJA = preload("res://core/scenes/card_icons/icon_ninja.tscn")
const SC_ICON_GREEN_UP = preload("res://core/scenes/card_icons/icon_green_up.tscn")

const SC_RC_SM_ICON_CRYPTO = preload("res://core/scenes/turn_panel/resource_counters/crypto_counter_sm.tscn")
const SC_RC_SM_ICON_GUNS = preload("res://core/scenes/turn_panel/resource_counters/guns_counter_sm.tscn")
const SC_RC_SM_ICON_TECH = preload("res://core/scenes/turn_panel/resource_counters/tech_counter_sm.tscn")
const SC_RC_SM_ICON_NINJA = preload("res://core/scenes/turn_panel/resource_counters/ninja_counter_sm.tscn")
