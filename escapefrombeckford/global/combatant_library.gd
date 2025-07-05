#class_name CombatantLibrary 
extends Node

var combatant_library = {}
const combatant_paths: Array[String] = [
	"res://fighters/Player/basic_player_data.tres",
	"res://fighters/MegaBlocker/basic_thrall_data.tres",
	"res://fighters/BasicClone/basic_clone_data.tres"
]

func compile_combatant_library():
	var combatant_id: int = 0
	for combatant_path in combatant_paths:
		var combatant_data: CombatantData = load(combatant_path)
		combatant_library[combatant_id] = combatant_data
		combatant_id += 1
