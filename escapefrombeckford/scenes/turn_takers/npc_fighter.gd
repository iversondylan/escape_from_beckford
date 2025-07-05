class_name NPCFighter extends Fighter

@onready var intent_container: IconViewPanel = $IconViewPanel

var npc_action_picker: NPCActionPicker
var current_action: NPCAction: set = set_current_action

func enter() -> void:
	do_turn()

func exit() -> void:
	update_action()

func _set_combatant_data(_combatant_data: CombatantData) -> void:
	
	combatant_data = _combatant_data
	name = combatant_data.name
	load_ai()
	if not combatant_data.combatant_data_changed.is_connected(update_data_visuals):
		combatant_data.combatant_data_changed.connect(update_data_visuals)
	if not combatant_data.combatant_data_changed.is_connected(update_action):
		combatant_data.combatant_data_changed.connect(update_action)
	load_combatant_data()
	update_data_visuals()

func do_turn() -> void:
	combatant_data.set_armor(0)
	combatant_data.reset_mana()
	if !current_action:
		#doing_turn = false
		#turn_complete = true
		#Events.turn_taker_turn_completed.emit()
		return
	current_action.perform_action()
	current_action = null
	intent_container.clear_display()

func set_current_action(_current_action: NPCAction) -> void:
	if !combatant_data.is_alive:
		return
	current_action = _current_action
	if current_action:
		var icon_dataz: Array[IconData]
		var icon_data: IconData = current_action.intent_icon.duplicate()
		#var icon_with_text: IconWithText = IconWithText.new(icon_texture, icon_string, icon_tooltip_text)
		current_action.update_action_intent()
		icon_dataz.push_back(icon_data)
		intent_container.display_icons(icon_dataz)

func load_ai() -> void:
	if npc_action_picker:
		npc_action_picker.queue_free()
	if combatant_data.ai:
		var new_action_picker: NPCActionPicker = combatant_data.ai.instantiate()
		add_child(new_action_picker)
		npc_action_picker = new_action_picker
		npc_action_picker.combatant = self

func update_action() -> void:
	if !npc_action_picker:
		return
	if !current_action:
		current_action = npc_action_picker.get_action()
		return
	var new_conditional_action := npc_action_picker.get_first_conditional_action()
	if new_conditional_action and current_action != new_conditional_action:
		current_action = new_conditional_action
