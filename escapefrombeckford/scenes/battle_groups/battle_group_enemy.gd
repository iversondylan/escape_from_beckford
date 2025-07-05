class_name BattleGroupEnemy extends BattleGroup

func _ready() -> void:
	turn_taker = $EnemyTurnTerminal
	#Events.combatant_died.connect(_combatant_died)
	#Events.combatant_actions_completed.connect(_on_combatant_actions_completed)
	#Events.friendly_turn_started.connect(_on_friendly_turn_started)
	Events.enemy_turn_started.connect(_on_enemy_turn_started)
	#Events.turn_taker_turn_completed.connect(_on_turn_taker_turn_complete) #MUST RESTORE THIS!!!!!!
	#Events.npc_action_completed.connect(_on_npc_action_completed)
	update_combatant_rank_variable()

func reboot_turn_taker(next_turn_taker: TurnTaker) -> void:
	if BattleController.current_state != BattleController.BattleState.ENEMY_TURN:
		return
	turn_taker = next_turn_taker
	turn_taker.enter()

func _on_turn_taker_turn_complete(turn_taker_who_finished: TurnTaker) -> void:
	if BattleController.current_state != BattleController.BattleState.ENEMY_TURN:
		return
	next_turn_taker(turn_taker_who_finished)

func _on_enemy_turn_started() -> void:
	start_turn()
