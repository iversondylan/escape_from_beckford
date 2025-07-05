#class_name CardLibrary 
extends Node

var card_library = {}
const card_paths: Array[String] = [
	"res://cards/AttackCard/attack_card.tres",
	"res://cards/DefendCard/defend_card.tres",
	"res://cards/SpectralCloneCard/spectral_clone.tres",
	"res://cards/SpacetimeWarp/spacetime_warp_data.tres",
]

func compile_card_library():
	var card_id: int = 0
	for card_path in card_paths:
		var card_data: CardData = load(card_path)
		card_library[card_id] = card_data
		card_id += 1
