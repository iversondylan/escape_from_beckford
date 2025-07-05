extends NPCAction

var spree: int = 0


func perform_action() -> void:
	if !combatant:
		return
	#if combatant.battle_group is BattleGroupEnemy:
		#target = GameState.battle_scene.get_front_combatant(0)
	#else:
		#target = GameState.battle_scene.get_front_combatant(1)
	#if target:
		var tween := create_tween().set_trans(Tween.TRANS_QUINT)
		#var start := combatant.global_position
		#var end := target.global_position# + Vector2.RIGHT * 32
		#var damage_effect := DamageEffect.new()
		#damage_effect.n_damage = n_damage
		#damage_effect.sound = sound
		#var target_array: Array[Fighter] = [target]
		spree += 1
		#tween.tween_property(combatant, "global_position", end, 0.4) #change time back to 0.4
		#tween.tween_callback(damage_effect.execute.bind(target_array))
		tween.tween_interval(0.25)
		#tween.tween_property(combatant, "global_position", start, 0.4)
		
		tween.finished.connect(
			func():
				#combatant.turn_complete = true
				action_performed.emit(self)
				combatant.turn_complete()
		)
	else:
		var tween := create_tween()
		tween.tween_interval(0.5)
		tween.finished.connect(
			func():
				#combatant.doing_turn = false
				#combatant.turn_complete = true
				action_performed.emit(self)
				combatant.turn_complete()
		)


func is_performable() -> bool:
	if spree <= 1:
		return true
	else:
		return false
#
func update_action_intent() -> void:
	intent_icon.text = ""

func other_action_performed(npc_action: NPCAction) -> void:
	spree = 0
