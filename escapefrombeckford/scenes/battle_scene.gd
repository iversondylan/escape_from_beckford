class_name BattleScene extends CanvasLayer

@onready var groups: Array[BattleGroup] = [$BattleGroupFriendly, $BattleGroupEnemy]

func add_combatant(fighter: Fighter, group: int, rank: int):
	groups[group].add_combatant(fighter, rank)

func remove_combatant(fighter: Fighter):
	for group in groups:
		group.remove_combatant(fighter)

func clear_combatants():
	for group in groups:
		group.clear_combatants()

func combatant_is_there(fighter: Fighter) -> bool:
	var is_it: bool = false
	for group: BattleGroup in groups:
		if group.combatant_is_there(fighter):
			is_it = true
	return is_it

func get_combatants_in_group(group_index: int) -> Array[Fighter]:
	#var fighters: Array[Fighter] = []
	return groups[group_index].get_combatants()

func get_combatants() -> Array[Fighter]:
	var fighters: Array[Fighter] = []
	for child_group in get_children():
		if child_group is BattleGroup:
			for fighter in child_group.get_combatants():
				fighters.push_back(fighter)
	return fighters

func get_summons() -> Array[Fighter]:
	var fighters: Array[Fighter] = []
	for child_group in get_children():
		if child_group is BattleGroup:
			for fighter in child_group.get_combatants():
				if fighter.combatant_data.team == 1:
					fighters.push_back(fighter)
	return fighters

func get_enemies() -> Array[Fighter]:
	var fighters: Array[Fighter] = []
	for child_group in get_children():
		if child_group is BattleGroup:
			for fighter in child_group.get_combatants():
				if fighter.combatant_data.team == 2:
					fighters.push_back(fighter)
	return fighters

func get_player() -> Player:
	var player: Player = null
	for child_group in get_children():
		if child_group is BattleGroup:
			for child_combatant in child_group.get_combatants():
				if child_combatant.combatant_data.team == 0:
					if !player:
						player = child_combatant
					else:
						print("ERROR: MORE THAN ONE PLAYER")
	return player

func set_player(new_player: Player) -> void:
	groups[0].player = new_player

func get_battle_groups() -> Array[BattleGroup]:
	var battle_groups: Array[BattleGroup] = []
	for child_group in get_children():
		if child_group is BattleGroup:
			battle_groups.push_back(child_group)
	return battle_groups

func get_front_combatant(battle_group_index: int) -> Fighter:
	var child_groups = get_battle_groups()
	#var child_combatants: Array[Fighter] = child_groups[battle_group_index].get_combatants()
	#var front_combatant: Fighter = null
	for child_combatant: Fighter in child_groups[battle_group_index].get_combatants():
		if child_combatant.combatant_data.is_alive:
			return child_combatant
	return null

func get_front_or_focus(battle_group_index: int) -> Fighter:
	var child_groups: Array[BattleGroup] = get_battle_groups()
	#var child_combatants: Array[Fighter] = child_groups[battle_group_index].get_combatants()
	#var front_combatant: Fighter = null
	if child_groups[battle_group_index].focus and child_groups[battle_group_index].focus.combatant_data.is_alive:
		return child_groups[battle_group_index].focus
	
	for child_combatant: Fighter in child_groups[battle_group_index].get_combatants():
		if child_combatant.combatant_data.is_alive:
			return child_combatant
	return null
