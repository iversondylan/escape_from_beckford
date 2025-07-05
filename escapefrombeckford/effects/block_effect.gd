class_name BlockEffect extends Effect

var n_armor: int = 0

func execute(targets: Array[Fighter]) -> void:
	for target in targets:
		if !target:
			continue
		target.add_armor(n_armor)
		SFXPlayer.play(sound)
