class_name UsableIcon extends Control
@export var icon_data: IconData
@onready var text: Label = $Text
@onready var icon: TextureRect = $Icon
#@onready var icon_area: Area2D = $IconArea

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass
	#set_icon_values()

func load_icon_data(_icon_data: IconData):
	icon_data = _icon_data
	set_icon_values()
	
	#for script in cardwithid.card.actions:
		#var action_script = RefCounted.new()
		#action_script.set_script(script)
		#actions.push_back(action_script)

#func highlight():
	#card_front_sprite2d.set_modulate(Color(1, 0.5, 0.1, 1))

#func unhighlight():
	#card_front_sprite2d.set_modulate(Color(1, 1, 1, 1))

#func get_cost() -> int:
	#return card_cost_int

#func activate(game_state: GameState) -> bool:
	#var action_processed: bool = false
	#for action in actions:
		#action_processed = action.activate(game_state)
	#return action_processed

func set_icon_values():
	#if text.get_text() != icon_with_text.counter_text:
		#text.set_text(icon_with_text.counter_text)
	text.text = icon_data.text
	icon.set_texture(icon_data.icon)

func _process(_delta: float) -> void:
	_update_graphics()

func _update_graphics():
	if text.get_text() != icon_data.text:
		text.set_text(icon_data.text)

#func _on_click_area_mouse_entered() -> void:
	#mouse_entered.emit(self)

#func _on_click_area_mouse_exited() -> void:
	#mouse_exited.emit(self)


func _on_mouse_entered() -> void:
	Events.icon_tooltip_show_requested.emit(self as UsableIcon)


func _on_mouse_exited() -> void:
	Events.icon_tooltip_hide_requested.emit()
