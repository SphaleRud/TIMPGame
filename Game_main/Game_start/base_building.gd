extends Node2D
@onready var hp=$text_hp
@onready var my_type="base"
@onready var max_hp=10
@onready var current_hp=max_hp
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func recive_damage(dmg):
	current_hp-=dmg
	hp.text=str(current_hp)

func destroy():
	hp.text=""
	$base_texture.texture=null
	$hp.visible=false
