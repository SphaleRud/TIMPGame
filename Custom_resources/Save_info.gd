class_name info_game
extends Resource
const save_game_path := "user://save.tres"

@export var score=0
@export var high_score={
		"value": 0,
		"date": ""
	}
@export var language="russian"
func write_savegame()->void:
	ResourceSaver.save(self,save_game_path)
	
static func load_savegame ():
	if not ResourceLoader.has_cached(save_game_path):
		return ResourceLoader.load(save_game_path,"",1)
