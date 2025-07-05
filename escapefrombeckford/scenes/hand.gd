class_name Hand extends Node2D

signal card_activated(card : UsableCard)

#@export var hand_radius_flt: float = $DebugShape.radius
@export var card_angle: float = 0
@export var card_angle_limit_flt: float = 35
@export var max_card_spread_angle_flt: float = 5
@onready var hand_cards_node: Node2D = $HandCardsNode
@onready var collision_shape: CollisionShape2D = $DebugShape
@onready var hand_radius_flt: float = collision_shape.shape.radius
@onready var usable_card_scn: PackedScene = preload("res://cards/UsableCard.tscn")

const CARD_DRAW_INTERVAL: float = 0.1
const CARD_DISCARD_INTERVAL: float = 0.1

var hand_cards_arr: Array[UsableCard] = []
var highlighted_card_index_int: int = -1
var currently_touched_cards_arr: Array[UsableCard] = []
var currently_selected_card_index: int = -1
var mouse_in_hand_area: bool = false
var held_card: UsableCard = null

func _ready() -> void:
	Events.card_played.connect(_on_card_played)
	Events.player_turn_started.connect(_on_player_turn_started)
	#Events.player_turn_ended.connect(_on_player_turn_ended)
	Events.card_drag_started.connect(_on_card_drag_started)
	Events.card_drag_ended.connect(_card_drag_or_aim_ended)
	Events.card_aim_ended.connect(_card_drag_or_aim_ended)
	Events.player_turn_completed.connect(_on_player_turn_completed)

func empty_hand():
	currently_selected_card_index = -1
	for card in hand_cards_arr:
		card.queue_free()
	hand_cards_arr = []
	currently_touched_cards_arr = []

func add_card(card: CardData) -> void:
	var usable_card = usable_card_scn.instantiate()
	usable_card.card_data = card
	var hand_size = hand_cards_arr.size()
	usable_card.original_index = hand_size
	hand_cards_arr.push_back(usable_card)
	hand_cards_node.add_child(usable_card)
	usable_card.position = Vector2(30, 540)
	#usable_card.load_card_data(card_with_id)
	usable_card.reparent_requested.connect(_on_usable_card_reparent_requested)
	usable_card.mouse_entered.connect(_handle_card_touched)
	usable_card.mouse_exited.connect(_handle_card_untouched)
	#usable_card.card_back_sprite2d.show()
	#usable_card.move_and_flip(Vector2(30, 500), 1)
	reposition_hand_cards()

func draw_card() -> void:
	add_card(Deck.draw_card())

func draw_cards(n_cards: int) -> void:
	var tween := create_tween()
	for i in range(n_cards):
		tween.tween_callback(draw_card)
		tween.tween_interval(CARD_DRAW_INTERVAL)
	
	tween.finished.connect(
		func():
			Events.hand_drawn.emit()
	)

func get_hand_cards() -> Array[UsableCard]:
	#var cards_in_hand: Array[UsableCard] = []
	#for card in hand_cards_node.get_children():
		#if card is UsableCard:
			#cards_in_hand.push_back(card)
	var cards_in_hand = hand_cards_arr.duplicate(false)
	return cards_in_hand

func reserve_summon_card(usable_card: UsableCard) -> void:
	#Deck.add_card_to_summon_reserve(usable_card.card_data)
	hand_cards_arr.erase(usable_card)
	usable_card.queue_free()

func discard_card(usable_card: UsableCard):
	Deck.add_card_to_discard(usable_card.card_data)
	hand_cards_arr.erase(usable_card)
	usable_card.queue_free()

func discard_cards(usable_cards: Array[UsableCard]):
	if usable_cards:
		var tween: Tween = create_tween()
		for usable_card in usable_cards:
			tween.tween_callback(Deck.add_card_to_discard.bind(usable_card.card_data))
			tween.tween_callback(usable_card.queue_free.bind())
			tween.tween_interval(CARD_DISCARD_INTERVAL)
		tween.finished.connect(
			func():
				Events.hand_discarded.emit()
		)
	else:
		Events.hand_discarded.emit()

func remove_card(index: int) -> UsableCard:
	var removing_card_usablecard = hand_cards_arr[index]
	hand_cards_arr.remove_at(index)
	#hand_cards_node.remove_child(removing_card_usablecard)
	
	update_original_index()
	reposition_hand_cards()
	currently_selected_card_index = -1
	#removing_card_node2d.queue_free()
	return removing_card_usablecard #node is not removed from memory!!! later must queue_free

func update_original_index() -> void:
	var index: int = 0
	for card in hand_cards_node.get_children():
		card.original_index = index
		index += 1

func remove_card_by_entity(card: UsableCard) -> UsableCard:
	var remove_index = hand_cards_arr.find(card)
	return remove_card(remove_index)

func remove_cards_by_entities(usable_cards: Array[UsableCard]) -> Array[UsableCard]:
	var removing_cards: Array[UsableCard]
	for usable_card in usable_cards:
		removing_cards.push_back(remove_card_by_entity(usable_card))
	return removing_cards

func disable_hand_cards() -> void:
	#currently_selected_card_index = -1
	for usable_card in hand_cards_arr:
		usable_card.unhighlight()
		usable_card.disabled = true
	#hand_cards_arr = []
	#currently_touched_cards_arr = []

func reposition_hand_cards():
	var card_spread_angle_flt : float = 0
	var current_card_angle_flt : float = 0
	var card_angle_increment_flt : float = 0
	if hand_cards_arr.size() >= 2:
		card_spread_angle_flt = min(card_angle_limit_flt, max_card_spread_angle_flt * (hand_cards_arr.size() - 1))
		current_card_angle_flt = - card_spread_angle_flt / 2
		card_angle_increment_flt = card_spread_angle_flt / (hand_cards_arr.size() - 1)
	for card in hand_cards_arr:
		_update_card_transform(card, current_card_angle_flt)
		current_card_angle_flt += card_angle_increment_flt

func _update_card_transform(usable_card: UsableCard, angle_in_drag: float) -> void:
	var pos: Vector2 = get_card_position(angle_in_drag)
	#var rot: float = deg_to_rad(angle_in_drag)
	usable_card.animate_to_position(pos, angle_in_drag, 0.5)
	#usablecard.set_position(get_card_position(angle_in_drag))
	#usablecard.set_rotation(deg_to_rad(angle_in_drag))

func _handle_card_touched(usablecard: UsableCard):
	if usablecard.card_state_machine.current_state.state == CardState.State.BASE:# and usablecard.disabled == false:
		currently_touched_cards_arr.push_back(usablecard)

func _handle_card_untouched(usablecard: UsableCard):
	usablecard.selected = false
	var index: int = currently_touched_cards_arr.find(usablecard)
	if index >= 0:
		currently_touched_cards_arr.remove_at(index)

func get_card_position(angle_deg_flt: float) -> Vector2:
	var x: float = hand_radius_flt * cos(deg_to_rad(angle_deg_flt+270))
	var y: float = hand_radius_flt * sin(deg_to_rad(angle_deg_flt+270))
	return collision_shape.position + Vector2(x, y)
# Called when the node enters the scene tree for the first time.



func on_click():
	if currently_selected_card_index >= 0:
		var card = hand_cards_arr[currently_selected_card_index] #remove_card(currently_selected_card_index)
		card_activated.emit(card)
		currently_selected_card_index = -1
		held_card = card
		held_card.set_usable_card_z_index(1)

#THIS SHOULD BE REWORKED TO USE SIGNALS INSTEAD OF PROCESS
func _process(_delta: float) -> void:
	for usablecard in hand_cards_arr:
		usablecard.unhighlight()
	currently_selected_card_index = -1
	if !currently_touched_cards_arr.is_empty():
		#currently_selected_card_index = -1
		
		for touched_card in currently_touched_cards_arr:
			touched_card.selected = false
			currently_selected_card_index = max(currently_selected_card_index, hand_cards_arr.find(touched_card))
		
		if held_card:
			held_card.highlight()
		elif currently_selected_card_index >= 0 && currently_selected_card_index < hand_cards_arr.size():
			hand_cards_arr[currently_selected_card_index].highlight()
		hand_cards_arr[currently_selected_card_index].selected = true

#THIS FUNCTION SHOULD BE RENAMED
func _on_usable_card_reparent_requested(_child: UsableCard) -> void:
	reposition_hand_cards()

func _on_card_played(usable_card: UsableCard):
	currently_touched_cards_arr.erase(usable_card)
	#held_card.set_usable_card_z_index(0)
	held_card = null

func _on_hand_area_mouse_entered() -> void:
	mouse_in_hand_area = true

func _on_hand_area_mouse_exited() -> void:
	mouse_in_hand_area = false

func _on_player_turn_started() -> void:
	draw_cards(5)

func _on_card_drag_started(_usable_card: UsableCard) -> void:
	_usable_card.set_usable_card_z_index(1)

func _card_drag_or_aim_ended(_usable_card: UsableCard) -> void:
	_usable_card.set_usable_card_z_index(0)
	held_card = null

#func _on_player_turn_ended() -> void:
	#pass

func _on_player_turn_completed() -> void:
	disable_hand_cards()
	discard_cards(remove_cards_by_entities(get_hand_cards()))
