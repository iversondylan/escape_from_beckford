class_name MenuCard extends CenterContainer

signal tooltip_requested(card_data: CardData)

@export var card_data: CardData : set = set_card
@onready var visuals: CardVisuals = $Visuals

#@onready var glow: Sprite2D = $Glow
#@onready var cost_blue: Label = %CostBlue
#@onready var cost_red: Label = %CostRed
#@onready var cost_green: Label = %CostGreen
#@onready var card_name: Label = $NameLabel
#@onready var card_art_rect: TextureRect = $CardArtRect

#@onready 

func set_card(_card: CardData) -> void:
	if !is_node_ready():
		await ready
	card_data = _card
	visuals.card_data = card_data
	
	#cost_red.text = str(_card.cost_red)
	#cost_green.text = str(_card.cost_green)
	#cost_blue.text = str(_card.cost_blue)
	#card_art_rect.texture = _card.texture

func _on_visuals_mouse_entered() -> void:
	visuals.glow.show()


func _on_visuals_mouse_exited() -> void:
	visuals.glow.hide()


func _on_visuals_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("mouse_click"):
		tooltip_requested.emit(card_data)
