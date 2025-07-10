class_name BattleRewardsScreen extends Control

#enum Type {GOLD, NEW_CARD, RELIC}

const CARD_REWARD = preload("res://scenes/card_reward.tscn")
const REWARD_BUTTON := preload("res://scenes/ui/reward_button.tscn")
const GOLD_TEXTURE := preload("res://assets/sprites/coin.PNG")
const GOLD_TEXT := "%s gold"
const CARD_TEXTURE := preload("res://assets/sprites/diamond_white.png")
const CARD_TEXT := "Add New Card"

@export var run_account: RunAccount
@export var player_data: CombatantData

@onready var rewards: VBoxContainer = %Rewards

var card_reward_total_weight : float = 0.0
var card_rarity_weights := {
	CardData.Rarity.COMMON: 0.0,
	CardData.Rarity.UNCOMMON: 0.0,
	CardData.Rarity.RARE: 0.0
}

func _ready() -> void:
	for node: Node in rewards.get_children():
		node.queue_free()
	
	#BELOW 3 LINES ARE FOR TESTING ONLY
	run_account = RunAccount.new()
	run_account.gold_changed.connect(func(): print("gold: %s" % run_account.gold))
	player_data = preload("res://fighters/Player/basic_player_data.tres").create_instance()
	
	add_gold_reward(77)
	add_card_reward()
	add_card_reward()

func add_gold_reward(n_gold: int) -> void:
	var gold_reward := REWARD_BUTTON.instantiate() as RewardButton
	gold_reward.reward_texture = GOLD_TEXTURE
	gold_reward.reward_text = GOLD_TEXT % n_gold
	gold_reward.pressed.connect(_on_gold_reward_taken.bind(n_gold))
	rewards.add_child.call_deferred(gold_reward)

func add_card_reward() -> void:
	var card_reward_button := REWARD_BUTTON.instantiate() as RewardButton
	card_reward_button.reward_texture = CARD_TEXTURE
	card_reward_button.reward_text = CARD_TEXT
	card_reward_button.pressed.connect(_show_card_reward)
	rewards.add_child.call_deferred(card_reward_button)

func _show_card_reward() -> void:
	if !run_account or !player_data:
		return
	
	var card_reward := CARD_REWARD.instantiate() as CardReward
	add_child(card_reward)
	#card_reward.card_reward_selected.connect(_on_card_reward_taken)

func _on_gold_reward_taken(n_gold: int) -> void:
	if !run_account:
		return
	run_account.gold += n_gold

func _on_back_button_pressed() -> void:
	Events.battle_rewards_exited.emit()
