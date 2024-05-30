class_name Empty_space
extends Node2D
var card
var my_place
var my_side
var my_type=null
var unit_ready
var attack_ready=false
var shilded=false
var current_hp:
	set(new_value):
		change_hp()
@onready var sprite=$sprite_space
@onready var hp=$HBoxContainer/HP
@onready var hp_icon=$HBoxContainer/hp_icon
@onready var attack=$HBoxContainer/attack
@onready var attack_icon=$HBoxContainer/attac_icon
# Called when the node enters the scene tree for the first time.
func change_hp() -> void:
	hp.text=current_hp
func _ready():
	pass
func _process(delta):
	pass

func _set_stats(value: Card,side,type,place)->void:
	my_place=place
	card=value
	hp_icon.visible=true
	my_type=type
	my_side=side
	if type=="building":
		sprite.texture=value.building
		hp.text=str(value.hp_building)
		attack.text=""
		attack_icon.visible=false
		unit_ready=true
	elif type=="unit":
		sprite.texture=value.troops
		hp.text=str(value.hp_unit)
		attack.text=str(value.dmg_attack)
		attack_icon.visible=true
		attack_ready=false
	if side=="player":
		sprite.flip_h=false
	if side=="enemy":
		sprite.flip_h=true
	
func attack_now(type):
	var dmg_mult=0
	if type=="base":
		dmg_mult=card.base_damage_mod
	elif type=="unit":
		dmg_mult=card.unit_damage_mod
	elif type=="building":
		dmg_mult=card.building_damage_mod
	return (card.dmg_attack*dmg_mult)


func recive_damage(dmg):
	if shilded==true:
		shilded=false
		hp.set("theme_override_colors/font_color", Color.RED)
	else:
		hp.text=str(int(int(hp.text)-dmg)/card.deffend_damage_mod)

func destroy():
	sprite.texture=null
	hp.text=""
	attack.text=""
	attack_icon.visible=false
	unit_ready=true
	shilded=false
	hp_icon.visible=false
	my_type=null
	my_side=null

func get_shield():
	if my_type!=null:
		shilded=true
		hp.set("theme_override_colors/font_color", Color.GRAY)
