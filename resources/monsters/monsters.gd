tool
extends Resource
class_name MonsterSource, "res://assets/misc/monster_resource_icon.svg"

export var id = ""
export var name = "no idea"

export(Texture) var texture = null
export var frames = 1

export var hit_points = 1
var current_hp: int

func _init():
	current_hp = hit_points
