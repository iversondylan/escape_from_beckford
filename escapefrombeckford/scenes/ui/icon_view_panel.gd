class_name IconViewPanel extends Node2D

#@onready var icon_container_scn: PackedScene = preload("res://scenes/ui/icon_container.tscn")
@onready var usable_icon_scn = preload("res://icon_data/usable_icon.tscn")
#@onready var usable_card_scn: PackedScene = preload("res://scenes/cards/UsableCard.tscn")
@onready var h_box_container = $HBoxContainer

func _ready() -> void:
	pass
	#$ColorRect.set_size($ScrollContainer.size)
	#$ColorRect.set_position($ScrollContainer.position)

func clear_display():
	for child in h_box_container.get_children():
		child.queue_free()


func display_icons(icons_dataz: Array[IconData]):
	clear_display()
	for icon_data: IconData in icons_dataz:
		var usable_icon = usable_icon_scn.instantiate()
		h_box_container.add_child(usable_icon)
		usable_icon.load_icon_data(icon_data)

func display_icons_from_data(icon_dataz: Array[IconData]) -> void:
	clear_display()
	for icon_data: IconData in icon_dataz:
		var usable_icon = usable_icon_scn.instantiate()
		h_box_container.add_child(usable_icon)
		usable_icon.load_icon_data(icon_data)
