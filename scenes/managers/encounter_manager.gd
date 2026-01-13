extends Node

export(PackedScene) var enemy_billboard_scene
export(NodePath) var player_path
export(NodePath) var camera_manager_path
export(Array, Resource) var monster_pool

export var edge_offset = 0.5
export var spacing_offset = 0.66

onready var player = get_node(player_path)
onready var camera_manager = get_node(camera_manager_path)

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	player.connect("tile_entered", self, "on_tile_entered")

func spawn_encounter_ahead():
	if monster_pool.empty():
		return
	
	var forward = player.get_forward_direction()
	var right = forward.cross(Vector3.UP).normalized()
	var base_transform = player.global_transform.origin + forward * (2 * edge_offset)
	
	var encountered_monsters = rng.randi_range(1, 4)
	
	for i in range(encountered_monsters):
		var enemy = enemy_billboard_scene.instance()
		self.get_parent().add_child(enemy)
		
		var offset = (i - (encountered_monsters - 1) / 2.0) * spacing_offset
		enemy.global_transform.origin = base_transform + right * offset
		
		enemy.attribute_monster(monster_pool[rng.randi_range(0, monster_pool.size() - 1)])
	
	camera_manager.battle_start()

func on_tile_entered(tile):
	if rng.randi_range(0, 100) < tile.base_encounter_rate:
		spawn_encounter_ahead()
