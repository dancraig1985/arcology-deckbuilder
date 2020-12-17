class_name Card
extends Node2D

signal card_data_updated(card)

var card_data := {}

onready var node_card_collision:= $CardCollision
onready var node_highlight := $Highlight

onready var node_card_name := $CardDisplay/Front/VBoxContainer/NamePlate/CardName
onready var node_card_art := $CardDisplay/Front/VBoxContainer/CardArt
onready var node_card_text := $CardDisplay/Front/VBoxContainer/TextPlate/CardText


func _ready():
	print_debug(str(node_card_collision))
	connect("card_data_updated", self, "_on_card_data_updated")
	
	#connect("mouse_entered", self, "_on_mouse_entered")
	#connect("mouse_exited", self, "_on_mouse_exited")


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


func _on_mouse_entered():
	print_debug("card z value: " + str(self.get_index()))
	set_highlight_visible(true)


func _on_mouse_exited():
	set_highlight_visible(false)


func set_highlight_visible(value := false) -> void:
	node_highlight.visible = value


