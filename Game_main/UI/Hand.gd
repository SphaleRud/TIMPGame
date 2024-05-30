class_name Hand
extends HBoxContainer
@export var deck: CardPile : set = _set_deck
@onready var card_preload = preload("res://Cards_main/card_default.tscn")
func _ready()->void:
	for child in get_children():
		var card_ui := child as CardUI
		card_ui.reparent_requested.connect(_on_card_ui_reparent_requested)
func _on_card_ui_reparent_requested (child: CardUI) ->void:
	child.reparent(self)
	

func _set_deck(value: CardPile) -> void:
	if not is_node_ready():
		await ready
	deck = value
	deck.shuffle()
func draw_card():
	if get_children().size()<=8:
		if deck.empty()!=true:
			var new_card_ui := card_preload.instantiate() as CardUI
			add_child(new_card_ui)
			new_card_ui.reparent_requested.connect(_on_card_ui_reparent_requested)
			new_card_ui.card =deck._get_random()
