extends RefCounted

var card_data: CardData

func activate(_targets: Array[Node]) -> bool:
	var action_processed = false
	if GameState.player.can_play_card(card_data):
		GameState.player.spend_mana(card_data)
		var block_effect = BlockEffect.new()
		block_effect.n_armor = 5
		block_effect.sound = card_data.sound
		block_effect.execute([GameState.player])
		action_processed = true
	return action_processed
