class_name BattleRewardsScreen extends Control

#enum Type {GOLD, NEW_CARD, RELIC}

const REWARD_BUTTON := preload("res://scenes/ui/reward_button.tscn")
const GOLD_TEXTURE := preload("res://assets/sprites/coin.PNG")
const GOLD_TEXT := "%s gold"
const CARD_TEXTURE := preload("res://assets/sprites/diamond_white.png")
const CARD_TEXT := "Add New Card"

@export var run_account: RunAccount
@onready var rewards: VBoxContainer = %Rewards

func _ready() -> void:
	for node: Node in rewards.get_children():
		node.queue_free()
	
	#BELOW 2 LINES ARE FOR TESTING ONLY
	run_account = RunAccount.new()
	run_account.gold_changed.connect(func(): print("gold: %s" % run_account.gold))
	
	add_gold_reward(77)

func add_gold_reward(n_gold: int) -> void:
	var gold_reward := REWARD_BUTTON.instantiate() as RewardButton
	gold_reward.reward_texture = GOLD_TEXTURE
	gold_reward.reward_text = GOLD_TEXT % n_gold
	gold_reward.pressed.connect(_on_gold_reward_taken.bind(n_gold))
	rewards.add_child.call_deferred(gold_reward)

func _on_gold_reward_taken(n_gold: int) -> void:
	if !run_account:
		return
	run_account.gold += n_gold

func _on_back_button_pressed() -> void:
	Events.battle_rewards_exited.emit()
