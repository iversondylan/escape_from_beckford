class_name Run
extends Node

const BATTLE_SCENE := preload("res://scenes/main.tscn")
const BATTLE_REWARDS_SCENE := preload("res://scenes/battle_rewards/battle_rewards.tscn")
const CAMPFIRE_SCENE := preload("res://scenes/campfire/campfire.tscn")
const MAP_SCENE := preload("res://scenes/map/map.tscn")
const SHOP_SCENE := preload("res://scenes/shop/shop.tscn")
const TREASURE_SCENE := preload("res://scenes/treasure/treasure_room.tscn")

@export var run_startup: RunStartup

@onready var current_view: Node = $CurrentView
@onready var gold_display: GoldDisplay = %GoldDisplay

@onready var collection_button: CardPileOpener = %CollectionButton
@onready var collection_pile_view: CardPileView = %CollectionPileView


@onready var map_button: Button = %MapButton
@onready var battle_button: Button = %BattleButton
@onready var shop_button: Button = %ShopButton
@onready var treasure_button: Button = %TreasureButton
@onready var rewards_button: Button = %RewardsButton
@onready var campfire_button: Button = %CampfireButton

var account: RunAccount
var player_character: CombatantData
var deck: CardPile

func _ready() -> void:
	if !run_startup:
		return
	
	match run_startup.startup_type:
		RunStartup.StartupType.NEW_RUN:
			player_character = run_startup.player_character.create_instance()
			deck = run_startup.deck.duplicate()
			print("run.gd STARTING RUN WITH NEW CHARACTER")
			_start_run()
		RunStartup.StartupType.CONTINUED_RUN:
			print("TO DO: load previous run")

func _start_run() -> void:
	account = RunAccount.new()
	GameRecord.account = account
	GameRecord.player_data = player_character
	GameRecord.deck = deck
	_connect_signals()
	_init_top_bar()
	print("TO DO: procedurally generate a map")

func _change_view(scene: PackedScene) -> void:
	if current_view.get_child_count() > 0:
		current_view.get_child(0).queue_free()
	
	get_tree().paused = false
	var new_view := scene.instantiate()
	current_view.add_child(new_view)

func _connect_signals() -> void:
	Events.battle_won.connect(_change_view.bind(BATTLE_REWARDS_SCENE))
	Events.battle_rewards_exited.connect(_change_view.bind(MAP_SCENE))
	Events.campfire_exited.connect(_change_view.bind(MAP_SCENE))
	Events.map_exited.connect(_on_map_exited)
	Events.shop_exited.connect(_change_view.bind(MAP_SCENE))
	Events.treasure_room_exited.connect(_change_view.bind(MAP_SCENE))
	
	battle_button.pressed.connect(_change_view.bind(BATTLE_SCENE))
	campfire_button.pressed.connect(_change_view.bind(CAMPFIRE_SCENE))
	map_button.pressed.connect(_change_view.bind(MAP_SCENE))
	rewards_button.pressed.connect(_change_view.bind(BATTLE_REWARDS_SCENE))
	shop_button.pressed.connect(_change_view.bind(SHOP_SCENE))
	treasure_button.pressed.connect(_change_view.bind(TREASURE_SCENE))

func _init_top_bar() -> void:
	gold_display.run_account = account
	collection_button.card_pile = GameRecord.deck
	collection_pile_view.card_pile = GameRecord.deck
	collection_button.pressed.connect(collection_pile_view.show_current_collection_view.bind("Collection"))

func _on_map_exited() -> void:
	print("TO DO: from the MAP, change view based on room type")
	
