extends Node2D
@onready var back=$background
@onready var animation_scale=0.0
@onready var col1=Color.PURPLE
@onready var col2=Color.DARK_GREEN
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if animation_scale <1.0:
		animation_scale+=0.006
		var col3=col1.lerp(col2,animation_scale)
		$background.set("modulate",col3)
	if animation_scale>=1.0:
		var col_temp=col2
		col2=col1
		col1=col_temp
		animation_scale=0.0


func _on_start_game_pressed():
	get_node("/root/Signals").global_score=0
	get_tree().change_scene_to_file("res://Game_main/game_main_screen.tscn")


func _on_exit_game_pressed():
	get_tree().quit()


func _on_load_game_pressed():
	var save_now=info_game.new()
	save_now=save_now.load_savegame()
	get_node("/root/Signals").global_score=save_now.score
	get_tree().change_scene_to_file("res://Game_main/game_main_screen.tscn")


func _on_rus_pressed():
	get_node("/root/Signals").global_language="rus"
	$buttons/start_game.text="Начать новую игру"
	$buttons/load_game.text="Загрузить игру"
	$buttons/exit_game.text="Выйти из игры"

func _on_eng_pressed():
	get_node("/root/Signals").global_language="eng"
	$buttons/start_game.text="Start new game"
	$buttons/load_game.text="Load game"
	$buttons/exit_game.text="Exit"


 
