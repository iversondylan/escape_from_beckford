extends NPCAction

@export var n_armor: int = 5

func perform_action() -> void:
	if !combatant or !target:
		return
	
	var block_effect := BlockEffect.new()
	block_effect.n_armor = n_armor
	block_effect.sound = sound
	block_effect.execute([combatant])
	
	get_tree().create_timer(0.6, false).timeout.connect( #CHANGE TIME BACK T0 0.6
		func():
			#combatant.doing_turn = false
			#combatant.turn_complete = true
			action_performed.emit(self)
			combatant.turn_complete()
	)

func is_performable() -> bool:
	return true
