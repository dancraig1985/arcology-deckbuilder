class_name Card
extends Node2D

var card_data := {}

onready var node_card_name:= $CardDisplay/Front/VBoxContainer/NamePlate/CardName
onready var node_card_art:= $CardDisplay/Front/VBoxContainer/CardArt
onready var node_card_text:= $CardDisplay/Front/VBoxContainer/TextPlate/CardText

signal card_data_updated(card)

func _ready():
	connect("card_data_updated", self, "_on_card_data_updated")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func import_card_data_from_dict(imported_card_data: Dictionary) -> void:
	card_data = imported_card_data
	emit_signal("card_data_updated", self)


func set_card_data_value(key: String, value) -> void:
	card_data[key] = value
	emit_signal("card_data_updated", self)


func _on_card_data_updated(card) -> void:
	node_card_name.text = card_data["Card Name"]
	node_card_art.texture = load("res://assets/card-art/" + card_data["Card Art"] + ".png")
	node_card_text.text = card_data["Card Text"]

	
	
