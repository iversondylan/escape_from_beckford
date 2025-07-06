class_name CardVisuals extends Control

@export var card_data: CardData : set = set_card_data

@onready var glow: Sprite2D = %Glow
@onready var card_front: TextureRect = %CardFront
@onready var cost_blue: Label = %CostBlue
@onready var cost_red: Label = %CostRed
@onready var cost_green: Label = %CostGreen
@onready var cost_container: Sprite2D = %CostContainer
@onready var name_label: RichTextLabel = %NameLabel
@onready var card_art_rect: TextureRect = %CardArtRect
@onready var description: RichTextLabel = %Description
@onready var rarity: TextureRect = %Rarity

func set_card_data(_card_data: CardData) -> void:
	if !is_node_ready():
		await  ready
	card_data = _card_data
	name_label.text = card_data.name
	cost_red.text = str(_card_data.cost_red)
	cost_green.text = str(_card_data.cost_green)
	cost_blue.text = str(_card_data.cost_blue)
	card_art_rect.texture = _card_data.texture
	rarity.modulate = CardData.RARITY_COLORS[card_data.rarity]
