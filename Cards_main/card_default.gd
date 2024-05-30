class_name CardUI
extends Control

func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	card_state_machine.init(self)
	Signals.connect("build_NOW",Callable(self, "_building"))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
signal reparent_requested(which_card_ui: CardUI)
@export var card: Card : set = _set_card
@onready var color: ColorRect=$Color_UI
@onready var state: Label=$State
@onready var drop_point_detector = $Drop_Point_detector
@onready var card_state_machine: CardStateMachine=$Card_state_machine as CardStateMachine
@onready var targets: Array[Node]=[]
@onready var Icon=$Icon
@onready var hp_unit=$HBoxContainer/HP_Unit
@onready var hp_building=$HBoxContainer/HP_Building
@onready var unit_attack=$HBoxContainer/ATTACK
func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)
		
func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()


func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()


func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	if not targets.has(area):
		targets.append(area)


func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	targets.erase(area)

func play ():
	card.play(targets)
	return (true)
	
func _building(this_card:Card) ->void:
	if state.text=="REALESED":
		queue_free()

func _set_card(value: Card) -> void:
	if not is_node_ready():
		await ready
	card = value
	Icon.texture=value.icon
	hp_unit.text=str(value.hp_unit)
	hp_building.text=str(value.hp_building)
	unit_attack.text=str(value.dmg_attack)
