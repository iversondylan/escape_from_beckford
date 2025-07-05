extends RefCounted

var card_data: CardData

func activate(targets: Array[Node]) -> bool:
	var warp_targets: Array[SummonedAlly] = []
	var action_processed: bool = false
	
	for target in targets:
		if target is CombatantTargetArea:
			if target.combatant is SummonedAlly:
				warp_targets.push_back(target.combatant)
	
	if GameState.player.can_play_card(card_data) && warp_targets:
		GameState.player.spend_mana(card_data)

		#SHOULD PROBABLY MAKE MOVE EFFECT TO PROCESS DIFFERENT KINDS OF MOVES AND PLAY SOUND
		for target in warp_targets:
			target.traverse_player()
		#damage_effect.sound = card_with_id.card_data.sound
		#damage_effect.execute(attack_targets)
		
		#priority = ActionData.attack_priority.NO_RETARGET
		#var action_data = ActionData.new(attack_damage, attack_count, attack_targets, attack_group, priority, armor_amount, armor_targets)
		#GameState.player.damage_targets(action_data)
		SFXPlayer.play(card_data.sound)
		action_processed = true
	
	return action_processed
