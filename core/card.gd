class_name Card
extends Node2D

onready var node_card_name: Label = $CardDisplay/Front/VBoxContainer/NamePlate/CardName
onready var node_card_art: TextureRect = $CardDisplay/Front/VBoxContainer/CardArt
onready var node_card_text: Label = $CardDisplay/Front/VBoxContainer/TextPlate/CardText


func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func setup_from_library(card_name: String = "Template"):
	var card_library: Dictionary = Dealer.card_library
	var card_dict = card_library[card_name]
	
	node_card_name.text = card_dict["Card Name"]
	node_card_art.texture = load("res://assets/card-art/" + card_dict["Card Art"] + ".png")
	node_card_text.text = card_dict["Card Text"]
	
	
	
	
