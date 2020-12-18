extends Node2D

signal card_data_updated(card)

var card_data := {}
var CardStackMachine

onready var node_card_collision:= $CardCollision
onready var node_highlight_mouse := $HighlightMouse
onready var node_card_tween := $CardTween

onready var node_card_name := $CardDisplay/Front/VBoxContainer/NamePlate/CardName
onready var node_card_art := $CardDisplay/Front/VBoxContainer/CardArt
onready var node_card_text := $CardDisplay/Front/VBoxContainer/TextPlate/CardText


func _ready():
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


func push_state(state_class: Script, new_args: Dictionary = {}) -> void:
	CardStackMachine.push(state_class, new_args)

func add_state(state_class: Script, new_args: Dictionary = {}) -> void:
	CardStackMachine.add(state_class, new_args)


func _on_card_data_updated(card) -> void:
	node_card_name.text = card_data["Card Name"]
	node_card_art.texture = load("res://assets/card-art/" + card_data["Card Art"] + ".png")
	node_card_text.text = card_data["Card Text"]


func _on_mouse_entered():
	Dealer.add_card_highlight_mouse_candidate(self)


func _on_mouse_exited():
	Dealer.remove_card_highlight_mouse_candidate(self)


func set_highlight_mouse_visible(value := false) -> void:
	node_highlight_mouse.visible = value


