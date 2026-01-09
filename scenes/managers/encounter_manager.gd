extends Node

export(PackedScene) var enemy_billboard_scene
export(NodePath) var player_path
export(NodePath) var camera_manager_path

export var edge_offset = 0.49

onready var player = get_node(player_path)
onready var camera_manager = get_node(camera_manager_path)

func _ready():
	player.connect("tile_entered", self, "on_tile_entered")

func spawn_encounter_ahead():
	var forward = player.get_forward_direction()
	var spawn_position = player.global_transform.origin + forward * (2 * edge_offset)
	
	var enemy = enemy_billboard_scene.instance()
	self.get_parent().add_child(enemy)
	enemy.global_transform.origin = spawn_position
	enemy.look_at(player.global_transform.origin, Vector3.UP)
	
	camera_manager.battle_start()

func on_tile_entered(tile):
	if randi() % 100 < tile.base_encounter_rate:
		spawn_encounter_ahead()
