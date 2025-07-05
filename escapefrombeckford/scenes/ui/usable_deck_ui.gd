class_name UsableDeckUI extends TextureButton

func draw_card() -> CardData:
	return Deck.draw_card()

func shuffle():
	Deck.shuffle()
