extends Node2D
@export var deck_enemy: CardPile : set = _set_deck
@onready var card_preload = preload("res://Cards_main/card_default.tscn")
@onready var card_draws: int: set= _set_card_draws
@onready var turn_count: int: set= _set_turn_count
@onready var mapping=[["base",null,null,null,null,"base"],["base",null,null,null,null,"base"],["base",null,null,null,null,"base"]]
@onready var sprite_mapping=[[$Out_Hand/Base_building_player,$Out_Hand/Line_1/Building_player/Empty_space,$Out_Hand/Line_1/Unit_player/Empty_space,$Out_Hand/Line_1/Unit_enemy/Empty_space,$Out_Hand/Line_1/Building_enemy/Empty_space,$Out_Hand/Base_building_enemy],
[$Out_Hand/Base_building_player,$Out_Hand/Line_2/Building_player/Empty_space,$Out_Hand/Line_2/Unit_player/Empty_space,$Out_Hand/Line_2/Unit_enemy/Empty_space,$Out_Hand/Line_2/Building_enemy/Empty_space,$Out_Hand/Base_building_enemy],
[$Out_Hand/Base_building_player,$Out_Hand/Line_3/Building_player/Empty_space,$Out_Hand/Line_3/Unit_player/Empty_space,$Out_Hand/Line_3/Unit_enemy/Empty_space,$Out_Hand/Line_3/Building_enemy/Empty_space,$Out_Hand/Base_building_enemy]]

func _set_card_draws(draws: int):
	card_draws=draws
	$BattleUI/Draw_count.text=str(card_draws)

func _set_turn_count(count: int):
	turn_count=count
	$BattleUI/Turn_count.text=str(turn_count)

func _ready():
		turn_count=1
		card_draws=1
		check_language()
		print(get_node("/root/Signals").global_language)
		Signals.connect("card_zone_selected",Callable(self, "_card_zone_selected"))
		$BattleUI/Best_score.text=str(get_node("/root/Signals").global_score)
func check_language():
	if get_node("/root/Signals").global_language=="рус":
		$BattleUI/Exit_button.text="Выход"
		$Deck_button.text="ВЗЯТЬ КАРТУ"
		$End_turn_button.text="КОНЕЦ ХОДА"
	if get_node("/root/Signals").global_language=="eng":
		$BattleUI/Exit_button.text="EXIT"
		$Deck_button.text="DRAW CARD"
		$End_turn_button.text="END TURN"

func _set_deck(value: CardPile) -> void:
	if not is_node_ready():
		await ready
	deck_enemy = value
	deck_enemy.shuffle()
func _process(delta):
	pass

func _on_deck_pressed():
	if card_draws>0:
		$BattleUI/Hand.draw_card()
		card_draws-=1

func get_my_place(target):
	if target==$Out_Hand/Line_1:
		return [0,1]
	elif target==$Out_Hand/Line_2:
		return [1,1]
	elif target==$Out_Hand/Line_3:
		return [2,1]

func _card_zone_selected (card: Card) ->void:
	var my_place=get_my_place(card.targ)
	if mapping[my_place[0]][my_place[1]]==null:
		mapping[my_place[0]][my_place[1]]=card
		_build(card,my_place)
		card.build_ready()
	
	
	
func _build(value: Card, place) -> void:
	sprite_mapping[place[0]][place[1]]._set_stats(value,"player","building",place)
	if value.name=="engi":
		sprite_mapping[0][0].hp.text=str(int(sprite_mapping[0][0].hp.text)+5)
	elif value.name=="mage":
		card_draws+=2
	elif value.name=="poor":
		var targ_1=clamp(place[0]+1,0,2)
		var targ_2=clamp(place[0]-1,0,2)
		if targ_1!=place[0]:
			sprite_mapping[targ_1][place[1]].destroy()
			mapping[targ_1][place[1]]=null
		if targ_2!=place[0]:
			sprite_mapping[targ_2][place[1]].destroy()
			mapping[targ_2][place[1]]=null
	elif value.name=="knight":
		var targ_1=clamp(place[0]+1,0,2)
		var targ_2=clamp(place[0]-1,0,2)
		if targ_1!=place[0]:
			sprite_mapping[targ_1][place[1]].get_shield()
		if targ_2!=place[0]:
			sprite_mapping[targ_2][place[1]].get_shield()
func _unit_out_player(value: Card, line,place) -> void:
	place+=1
	sprite_mapping[line][place]._set_stats(value,"player","unit",place)
func _get_targets(my_line,my_place,my_side):
		var attack=false
		var temp_place=my_place
		while attack!=true:
			temp_place+=my_side
			if sprite_mapping[my_line][temp_place].my_type!=null:
				print(temp_place)
				attack=true

		return(temp_place)
func _on_end_turn_button_pressed():
	card_draws=1
	for line_test in range(0,3):
		if mapping[line_test][1]!=null:
			if sprite_mapping[line_test][1].unit_ready==true: #выпуск_юнитов
				sprite_mapping[line_test][1].unit_ready=false
				_unit_out_player(mapping[line_test][1],line_test,1)
				mapping[line_test][2]="unit"
		if mapping[line_test][2]!=null:
			if sprite_mapping[line_test][2].attack_ready==false:
				sprite_mapping[line_test][2].attack_ready=true
			elif sprite_mapping[line_test][2].attack_ready==true:
				var target_for_attack=_get_targets(line_test,2,1)
				sprite_mapping[line_test][target_for_attack].recive_damage(
				sprite_mapping[line_test][2].attack_now(sprite_mapping[line_test][target_for_attack].my_type))
	enemy_turn_start()
				
func enemy_turn_start():
	randomize()
	var enemy_place=[randi_range(0,2),4]
	mapping[enemy_place[0]][4]=deck_enemy._get_random()
	_enemy_build(mapping[enemy_place[0]][4],enemy_place)
	for line_test in range(0,3):
		if mapping[line_test][4]!=null:
			if sprite_mapping[line_test][4].unit_ready==true: #выпуск_юнитов
				sprite_mapping[line_test][4].unit_ready=false
				_unit_out_enemy(mapping[line_test][4],line_test,4)
				mapping[line_test][3]="unit"
		if mapping[line_test][3]!=null:
				if sprite_mapping[line_test][3].attack_ready==false:
					sprite_mapping[line_test][3].attack_ready=true
				elif sprite_mapping[line_test][3].attack_ready==true:
		
					var target_for_attack=_get_targets(line_test,3,-1)
					print (target_for_attack)
					sprite_mapping[line_test][target_for_attack].recive_damage(
					sprite_mapping[line_test][3].attack_now(sprite_mapping[line_test][target_for_attack].my_type))
	calculate_damage()
	turn_count+=1
func _unit_out_enemy(value: Card, line,place) -> void:
	place-=1
	sprite_mapping[line][place]._set_stats(value,"enemy","unit",place)

func _enemy_build(value: Card, place) -> void:
	sprite_mapping[place[0]][place[1]]._set_stats(value,"enemy","building",place)

func calculate_damage():
	for line in range(0,3):
		for place_now in range(0,6):
			if int(sprite_mapping[line][place_now].hp.text)<=0:
				sprite_mapping[line][place_now].destroy()
				mapping[line][place_now]=null
	if int(sprite_mapping[2][0].hp.text)<=0:
		get_tree().change_scene_to_file("res://Game_main/main_menu.tscn")
	elif int(sprite_mapping[2][5].hp.text)<=0:
		get_node("/root/Signals").global_score+=1
		get_tree().change_scene_to_file("res://Game_main/game_main_screen.tscn")


func _on_exit_button_pressed():
	var save_now=info_game.new()
	save_now.score=get_node("/root/Signals").global_score
	save_now.write_savegame()
	get_tree().change_scene_to_file("res://Game_main/main_menu.tscn")
