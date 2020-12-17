extends Node

var card_library := CardLibrary.new()

var is_board_set_up := false
var card_to_update
var is_card_updated := false

var card_scene := preload("res://core/scenes/card.tscn")

onready var main_node = get_tree().get_root().get_node("Main")

func _ready():	
	pass

func instance_card(card_name: String = "Template", spawn_position: Vector2 = Vector2(0, 0)):
	var card_node = card_scene.instance()
	var card_data = card_library.get_card_data(card_name)
	main_node.add_child(card_node)
	card_node.position = spawn_position
	card_node.import_card_data_from_dict(card_data)
	print_debug("card_data instanced: " + str(card_data))
	print_debug("card instanced at: " + str(card_node.position))
	return card_node

func _process(delta):
	if not is_board_set_up:
		instance_card("Arcology Prime", Vector2(10, 10))
		card_to_update = instance_card("Console Cowboy", Vector2(200, 10))
		instance_card("Arcology Prime", Vector2(10, 300))
		is_board_set_up = true

