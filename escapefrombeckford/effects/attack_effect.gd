class_name AttackEffect
extends Effect

#var attacker: Fighter
enum RetargetPriority {NONE, FRONT}
var targets: Array[Fighter] = []
var n_damage: int = 0
var n_attacks: int = 1
var retarget_priority: RetargetPriority = RetargetPriority.FRONT
var explode: bool = false

var target_battle_group_index: int
var tween: Tween

func execute(attacker: Array[Fighter]) -> void:
	if !attacker:
		return
	if targets:
		attacker[0].attack(targets, n_damage, n_attacks, retarget_priority, explode)
