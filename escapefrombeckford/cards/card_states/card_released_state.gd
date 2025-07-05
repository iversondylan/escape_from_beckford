extends CardState

var played: bool

func enter() -> void:
	#usable_card.state.text = "RELEASED"
	played = false

	if !usable_card.targets.is_empty():
		played = usable_card.activate()
	

	
	#THIS SHOULD PROBABLY BE REPLACED LATER
	#transition_requested.emit(self, CardState.State.BASE)

func dwell() -> void:
	transition_requested.emit(self, CardState.State.BASE)

func on_input(_event: InputEvent) -> void:
	if played:
		return
	
	transition_requested.emit(self, CardState.State.BASE)
