extends Reference
class_name EncounterManager

var handler: Node
var enemy_billboard_scene: PackedScene
var player: Node
var camera_manager: CameraManager
var monster_pool: Array
var scene_root: Node
var edge_offset = 0.49
var spacing_offset = 0.66

var rng = RandomNumberGenerator.new()

func _init(player_node, camera_manager_script, scene):
	player = player_node
	camera_manager = camera_manager_script
	scene_root = scene
	rng.randomize()

func set_monster_pool(pool):
	monster_pool = pool

func set_enemy_billboard_scene(scene):
	enemy_billboard_scene = scene

func spawn_encounter_ahead():
	if monster_pool.empty():
		return
	
	var forward = player.get_forward_direction()
	var right = forward.cross(Vector3.UP).normalized()
	var base_transform = player.global_transform.origin + forward * (2 * edge_offset)
	
	var encountered_monsters = rng.randi_range(1, 4)
	
	for i in range(encountered_monsters):
		var enemy = enemy_billboard_scene.instance()
		scene_root.add_child(enemy)
		
		var offset = (i - (encountered_monsters - 1) / 2.0) * spacing_offset
		enemy.global_transform.origin = base_transform + right * offset
		
		enemy.attribute_monster(monster_pool[rng.randi_range(0, monster_pool.size() - 1)])
	
	camera_manager.battle_start()

func on_tile_entered(tile):
	if rng.randi_range(0, 100) < tile.base_encounter_rate:
		spawn_encounter_ahead()

func end_encounter():
	camera_manager.battle_end()
	for element in scene_root.get_tree().get_nodes_in_group("battle node"):
		element.queue_free()
