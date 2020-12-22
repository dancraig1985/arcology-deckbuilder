class_name Card
extends Node2D

signal card_data_updated(card)
signal is_facedown_updated(value)
signal is_for_sale_to_player_updated(value)

var card_data := {}
var CardStackMachine

var deck
var is_facedown: bool = false
var is_for_sale_to_player: bool = false

var is_acting: bool = false

# Assigned on creation by Dealer
onready var node_dealer: Node

onready var node_card_collision:= $CardCollision
onready var node_highlight_mouse := $HighlightMouse
onready var node_highlight_target := $HighlightTarget
onready var node_card_tween := $CardTween

onready var node_front := $CardDisplay/Front
onready var node_back := $CardDisplay/Back

onready var node_card_name := $CardDisplay/Front/VBoxContainer/NamePlate/CardName
onready var node_card_art := $CardDisplay/Front/VBoxContainer/CardArt
onready var node_card_text := $CardDisplay/Front/VBoxContainer/TextPlate/VBoxContainer/Effect1/CardText
onready var node_card_icons := $CardDisplay/Front/VBoxContainer/TextPlate/VBoxContainer/IconsPanel/Icons

onready var node_card_cost_icons := $CostPanel

func _ready():
	add_to_group(Constants.NODE_GROUPS.CARDS)
	connect("card_data_updated", self, "_on_card_data_updated")
	connect("is_facedown_updated", self, "_on_card_is_facedown_updated")
	connect("is_for_sale_to_player_updated", self, "_on_is_for_sale_to_player_updated")
	
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

func get_card_data_value(key: String):
	return card_data[key]

func set_card_cost(new_cost: Dictionary = {}) -> void:
	set_card_data_value("Card Cost", new_cost)
	emit_signal("card_data_updated", self)

func get_card_cost() -> Dictionary:
	return get_card_data_value("Card Cost")

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
	emit_signal("is_facedown_updated", value)

func get_is_facedown() -> bool:
	return is_facedown

func flip() -> void:
	node_front.visible = not node_front.visible
	node_back.visible = not node_front.visible

func add_card_icon(icon_name: String) -> void:
	var new_icon: Node
	match icon_name:
		"Crypto":
			new_icon = Constants.SC_ICON_CRYPTO.instance()
		"Heart":
			new_icon = Constants.SC_ICON_HEART.instance()
		"Guns":
			new_icon = Constants.SC_ICON_GUNS.instance()
		"Tech":
			new_icon = Constants.SC_ICON_TECH.instance()
		"Ninja":
			new_icon = Constants.SC_ICON_NINJA.instance()
		"Draw":
			new_icon = Constants.SC_ICON_GREEN_UP.instance()
	
	if new_icon:
		node_card_icons.add_child(new_icon)

func remove_all_icons() -> void:
	for card_icon in node_card_icons.get_children():
		card_icon.queue_free()

func add_card_cost_icon(resource_name: String, resource_cost: int) -> void:
	var new_rc: Node
	match resource_name:
		"Crypto":
			new_rc = Constants.SC_RC_SM_ICON_CRYPTO.instance()
		"Guns":
			new_rc = Constants.SC_RC_SM_ICON_GUNS.instance()
		"Ninja":
			new_rc = Constants.SC_RC_SM_ICON_NINJA.instance()
		"Tech":
			new_rc = Constants.SC_RC_SM_ICON_TECH.instance()

	if new_rc and resource_cost > 0:
		var node_new_icon_label = new_rc.get_node("Center/HBox/ResourceLabel")
		node_new_icon_label.text = str(resource_cost)
		node_card_cost_icons.add_child(new_rc)

func remove_all_cost_icons() -> void:
	for i in node_card_cost_icons.get_children():
		i.queue_free()

func set_cost_icons_visible(value: bool) -> void:
	node_card_cost_icons.visible = value

func set_is_for_sale_to_player(value: bool = not is_for_sale_to_player) -> void:
	is_for_sale_to_player = value
	set_cost_icons_visible(value)
	emit_signal("is_for_sale_to_player_updated", value)

func get_is_for_sale_to_player() -> bool:
	return is_for_sale_to_player

func _on_mouse_entered():
	if node_dealer:
		node_dealer.add_card_highlight_mouse_candidate(self)

func _on_mouse_exited():
	if node_dealer:
		node_dealer.remove_card_highlight_mouse_candidate(self)

func _on_card_data_updated(card) -> void:
	node_card_name.text = card_data["Card Name"]
	node_card_art.texture = load("res://assets/art/card_art/" + card_data["Card Art"] + ".png")
	node_card_text.text = card_data["Card Text"]
	
	remove_all_icons()
	for i in card_data["Card Icons"]:
		add_card_icon(i)
	
	remove_all_cost_icons()
	var card_cost = get_card_cost()
	for i in card_cost.keys():
		add_card_cost_icon(i, card_cost[i])

func _on_card_is_facedown_updated(value: bool) -> void:
	node_front.visible = not value
	node_back.visible = value
	if value:
		set_cost_icons_visible(not value)
	else:
		if get_is_for_sale_to_player():
			set_cost_icons_visible(not value)

func _on_is_for_sale_to_player_updated(value: bool) -> void:
	if value and not get_is_facedown():
		set_cost_icons_visible(value)
	else:
		set_cost_icons_visible(false)

func set_highlight_mouse_visible(value := false) -> void:
	node_highlight_mouse.visible = value

func set_highlight_target_visible(value := false) -> void:
	node_highlight_target.visible = value

func push_state(state_class: Script, new_args: Dictionary = {}) -> void:
	CardStackMachine.push(state_class, new_args)

func add_state(state_class: Script, new_args: Dictionary = {}) -> void:
	CardStackMachine.add(state_class, new_args)

func set_is_acting(value: bool) -> void:
	is_acting = value

func get_is_acting() -> bool:
	return is_acting
