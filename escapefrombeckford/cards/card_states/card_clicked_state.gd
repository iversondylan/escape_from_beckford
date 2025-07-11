extends CardState

func enter() -> void:
	#usable_card.state.text = "CLICKED"
	usable_card.drop_point_detector.monitoring = true

func on_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		transition_requested.emit(self, CardState.State.DRAGGING)
