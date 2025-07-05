class_name EnemyTurnTerminal extends TurnTaker

func enter() -> void:
	BattleController.transition(BattleController.BattleState.FRIENDLY_TURN)
