class_name FriendlyTurnTerminal extends TurnTaker

func enter() -> void:
	BattleController.transition(BattleController.BattleState.ENEMY_TURN)
