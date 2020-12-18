extends Node


func _ready():
	get_viewport().connect("size_changed", self, "_on_viewport_size_changed")


func _on_viewport_size_changed():
	print_debug("New viewport size: " + str(get_viewport().size))
	#$Background.rect_size = get_viewport().size



