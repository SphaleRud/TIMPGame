class_name Stats_building
extends Resource
signal stats_changed

@export var max_health:=1
@export var art: Texture
var health: int: set=set_health

func set_health(value: int) -> void:
	health = clampi(value,0,max_health)
	stats_changed.emit()

func take_damage(damage: int) -> void:
	if damage <=0:
		return
	var initial_damaage=damage
	damage=clampi(damage,0,damage)
	self.health -=damage
	if health<=0:
		destroyed()
	
	
func heal(amount: int)->void:
	self.health+=amount


func create_instance() -> Resource:
	var instance: Stats_building=self.duplicate()
	instance.health=max_health
	return instance

func destroyed()->void:
	pass
