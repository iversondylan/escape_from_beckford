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

func _on_back_button_pressed() -> void:
	Events.battle_rewards_exited.emit()
