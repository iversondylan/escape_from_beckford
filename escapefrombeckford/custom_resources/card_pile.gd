class_name CardPile extends Resource

signal card_pile_size_changed(cards_amount)

@export var cards: Array[CardData] = []


func is_empty() -> bool:
	return cards.is_empty()


func draw_front() -> CardData:
	var card = cards.pop_front()
	card_pile_size_changed.emit(cards.size())
	return card

func draw_back() -> CardData:
	var card = cards.pop_back()
	card_pile_size_changed.emit(cards.size())
	return card

func add_back(card: CardData) -> void:
	cards.push_back(card)
	card_pile_size_changed.emit(cards.size())


func shuffle() -> void:
	cards.shuffle()


func clear() -> void:
	cards.clear()
	card_pile_size_changed.emit(cards.size())


func _to_string() -> String:
	var _card_strings: PackedStringArray = []
	for i in range(cards.size()):
		_card_strings.append("%s: %s" % [i+1, cards[i].id])
	return "\n".join(_card_strings)
