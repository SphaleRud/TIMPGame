class_name Card
extends Resource
var targ
var unit_on_ready=false
var line=0
var place=0
var side
@export_group("Card Attributes")
@export var id: int
@export var name: String
@export var hp_building: int
@export var hp_unit: int
@export var dmg_attack: int
@export var base_damage_mod: int
@export var unit_damage_mod: int
@export var building_damage_mod: int
@export var deffend_damage_mod: int

@export_group("Card_visuals")
@export var building: Texture
@export var troops: Texture
@export var icon:Texture
@export_multiline var tooltip_text: String



func play(targets: Array[Node]) ->void:
	targ=targets[0]
	before_build()

func before_build() -> void:
	Signals.emit_signal("card_zone_selected",self)

func build_ready() ->void:
	Signals.emit_signal("build_NOW",self)

		
