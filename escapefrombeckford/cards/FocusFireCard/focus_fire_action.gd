extends RefCounted

var card_data: CardData

func activate(targets: Array[Node]) -> bool:
	var focus_target: Array[Fighter] = []
	#var attack_group: int = 0
	#var priority: ActionData.attack_priority = ActionData.attack_priority.NO_ATTACK
	#var armor_amount: int = 0
	#var armor_targets: Array[Fighter] = []
	var action_processed: bool = false
	
	for target in targets:
		if target is CombatantTargetArea:
			if target.combatant is Enemy:
				focus_target.push_back(target.combatant)
	
	if !GameState.player.can_play_card(card_data) or !focus_target:
		return action_processed
	
	GameState.player.spend_mana(card_data)
	#attack_group = 1
	
	var focus_effect := FocusEffect.new()
	focus_effect.sound = card_data.sound
	focus_effect.execute(focus_target)
	action_processed = true
	return action_processed
