class_name NPCActionPicker extends Node

@export var combatant: NPCFighter: set = _set_combatant
@export var target: Fighter: set = _set_target

@onready var total_weight: float = 0.0

func _ready() -> void:
	target = GameState.battle_scene.get_front_combatant(0)
	_connect_children()
	make_chances()

func get_action() -> NPCAction:
	var action := get_first_conditional_action()
	if action:
		action.update_action_intent()
		return action
	action = get_chance_based_action()
	action.update_action_intent()
	return action

func get_first_conditional_action() -> NPCAction:
	var action: NPCAction
	for child in get_children():
		action = child as NPCAction
		if !action or action.choice_type != NPCAction.ChoiceType.CONDITIONAL:
			continue
		if action.is_performable() and action.choice_type == NPCAction.ChoiceType.CONDITIONAL:
			return action
	return null

func get_chance_based_action() -> NPCAction:
	make_chances()
	var action: NPCAction
	var roll := randf_range(0.0, total_weight)
	for child in get_children():
		action = child as NPCAction
		if not action or action.choice_type != NPCAction.ChoiceType.CHANCE:
			continue
		if action.accumulated_weight > roll:
			return action
	return null

func make_chances() -> void:
	var action: NPCAction
	total_weight = 0
	for child in get_children():
		action = child as NPCAction
		if !action or action.choice_type != NPCAction.ChoiceType.CHANCE:
			continue
		elif action.is_performable():
			total_weight += action.chance_weight
			action.accumulated_weight = total_weight
		else:
			action.accumulated_weight = 0

func _connect_children() -> void:
	for child in get_children():
		child.action_performed.connect(_on_npc_action_performed)

func _set_combatant(_combatant: NPCFighter) -> void:
	combatant = _combatant
	for action in get_children():
		action.combatant = combatant

func _set_target(_combatant: Fighter) -> void:
	target = _combatant
	for action in get_children():
		action.target = target
		
func _on_npc_action_performed(npc_action: NPCAction) -> void:
	for child in get_children():
		if child != npc_action:
			child.other_action_performed(npc_action)
