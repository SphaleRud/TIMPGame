extends CardState

var played: bool

func enter() ->void:
	card_ui.color.color=Color.DARK_VIOLET
	card_ui.state.text="REALESED"

	played = false
	
	if not card_ui.targets.is_empty():
		card_ui.play()
	played=false


func on_input(_event: InputEvent) -> void:
	if played:
		return
	card_ui.state.text="BASE"
	transition_requested.emit(self, CardState.State.BASE)
