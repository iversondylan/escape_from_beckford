extends Control

const RUN_SCENE = preload("res://scenes/run/run.tscn")
const COLE_STATS := preload("res://fighters/Player/basic_player_data.tres")
const COLE_BASIC_DECK := preload("res://fighters/Player/cole_basic_deck.tres")

@export var run_startup: RunStartup

@onready var title: Label = %Title
@onready var description: Label = %Description
@onready var character_image: TextureRect = %CharacterImage

var current_character: CombatantData : set = set_current_character
var current_deck: CardPile : set = set_current_card_pile

func _ready() -> void:
	set_current_character(COLE_STATS)
	set_current_card_pile(COLE_BASIC_DECK)
	
func set_current_character(new_character: CombatantData) -> void:
	current_character = new_character
	title.text = current_character.name
	description.text = current_character.description
	character_image.texture = current_character.character_art

func set_current_card_pile(new_deck: CardPile) -> void:
	current_deck = new_deck

func _on_start_button_pressed() -> void:
	print("Start new escape attempt with %s" % current_character.name)
	run_startup.startup_type = RunStartup.StartupType.NEW_RUN
	run_startup.player_character = current_character
	run_startup.deck = current_deck
	get_tree().change_scene_to_packed(RUN_SCENE)


func _on_cole_button_pressed() -> void:
	current_character = COLE_STATS
	current_deck = COLE_BASIC_DECK


func _on_char_2_button_pressed() -> void:
	current_character = COLE_STATS
	current_deck = COLE_BASIC_DECK


func _on_char_3_button_pressed() -> void:
	current_character = COLE_STATS
	current_deck = COLE_BASIC_DECK
