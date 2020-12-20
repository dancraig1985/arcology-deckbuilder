class_name Card
extends Node2D

signal card_data_updated(card)

var card_data := {}
var CardStackMachine

var is_facedown: bool = false
var is_acting: bool = false

# Assigned on creation by Dealer
onready var node_dealer: Node

onready var node_card_collision:= $CardCollision
onready var node_highlight_mouse := $HighlightMouse
onready var node_card_tween := $CardTween

onready var node_front := $CardDisplay/Front
onready var node_back := $CardDisplay/Back


onready var node_card_name := $CardDisplay/Front/VBoxContainer/NamePlate/CardName
onready var node_card_art := $CardDisplay/Front/VBoxContainer/CardArt
onready var node_card_text := $CardDisplay/Front/VBoxContainer/TextPlate/CardText


func _ready():
	add_to_group(Constants.NODE_GROUPS.CARDS)
	connect("card_data_updated", self, "_on_card_data_updated")
	node_card_collision.connect("mouse_entered", self, "_on_mouse_entered")
	node_card_collision.connect("mouse_exited", self, "_on_mouse_exited")
	
	CardStackMachine = Constants.STACK_MACHINE.new(self, Constants.ST_CARD_IDLE)


func _process(delta):
	CardStackMachine.process(delta)

func import_card_data_from_dict(imported_card_data: Dictionary) -> void:
	card_data = imported_card_data
	emit_signal("card_data_updated", self)

func set_card_data_value(key: String, value) -> void:
	card_data[key] = value
	emit_signal("card_data_updated", self)

func set_z_index(value: int = 0) -> void:
	z_index = value

func set_card_scale(value: float = 1.0) -> void:
	scale = Vector2(value, value)

func move_to_position(target_position: Vector2, target_scale: Vector2) -> void:
	add_state(Constants.ST_CARD_MOVE_TO_POSITION, {
		target_position = target_position,
		target_scale = target_scale})

func set_is_facedown(value: bool = true) -> void:
	is_facedown = value
	node_front.visible = not is_facedown
	node_back.visible = is_facedown


func flip() -> void:
	node_front.visible = not node_front.visible
	node_back.visible = not node_front.visible


func _on_card_data_updated(card) -> void:
	node_card_name.text = card_data["Card Name"]
	node_card_art.texture = load("res://assets/art/card_art/" + card_data["Card Art"] + ".png")
	node_card_text.text = card_data["Card Text"]


func _on_mouse_entered():
	if node_dealer:
		node_dealer.add_card_highlight_mouse_candidate(self)


func _on_mouse_exited():
	if node_dealer:
		node_dealer.remove_card_highlight_mouse_candidate(self)


func set_highlight_mouse_visible(value := false) -> void:
	node_highlight_mouse.visible = value

func push_state(state_class: Script, new_args: Dictionary = {}) -> void:
	CardStackMachine.push(state_class, new_args)

func add_state(state_class: Script, new_args: Dictionary = {}) -> void:
	CardStackMachine.add(state_class, new_args)

func set_is_acting(value: bool) -> void:
	is_acting = value

func get_is_acting() -> bool:
	return is_acting
