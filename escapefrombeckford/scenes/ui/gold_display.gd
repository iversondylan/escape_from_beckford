class_name GoldDisplay extends HBoxContainer

@export var run_account: RunAccount : set = set_run_account

@onready var label: Label = $Label

func _ready() -> void:
	label.text = "0"

func set_run_account(new_account: RunAccount) -> void:
	run_account = new_account
	if !run_account.gold_changed.is_connected(_update_gold):
		run_account.gold_changed.connect(_update_gold)
		_update_gold()

func _update_gold() -> void:
	label.text = str(run_account.gold)
	
