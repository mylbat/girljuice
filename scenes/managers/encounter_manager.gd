extends Node

export(PackedScene) var enemy_billboard_scene
export(NodePath) var player_path
export(NodePath) var camera_manager_path
export(Array, Resource) var monster_pool

export var edge_offset = 0.49

onready var player = get_node(player_path)
onready var camera_manager = get_node(camera_manager_path)

var rng = RandomNumberGenerator.new()

func _ready():
	player.connect("tile_entered", self, "on_tile_entered")

func spawn_encounter_ahead():
	if monster_pool.empty():
		return
	
	var forward = player.get_forward_direction()
	var spawn_position = player.global_transform.origin + forward * (2 * edge_offset)
	
	var enemy = enemy_billboard_scene.instance()
	self.get_parent().add_child(enemy)
	enemy.global_transform.origin = spawn_position
	
	enemy.attribute_monster(monster_pool[0])
	
	camera_manager.battle_start()

func on_tile_entered(tile):
	rng.randomize()
	if rng.randi_range(0, 100) < tile.base_encounter_rate:
		spawn_encounter_ahead()
