extends Node


const STACK_MACHINE_PATH: String = "res://core/classes/stack_machine/stack_machine.gd"
const STACK_MACHINE: Script = preload(STACK_MACHINE_PATH)

const ST_TEMPLATE: Script = preload("res://core/classes/stack_machine/states/st_template.gd")
const ST_CARD_IDLE: Script = preload("res://core/classes/stack_machine/states/cards/st_card_idle.gd")
