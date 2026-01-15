extends Node

export(NodePath) var player_path
export(PackedScene) var enemy_billboard_scene
export(Array, Resource) var monster_pool
export(Array, Resource) var active_party

onready var camera_manager: CameraManager
onready var encounter_manager: EncounterManager
onready var party_manager: PartyManager

onready var player = get_node(player_path)

func _ready():
	initialise_managers()
	connect_signals()

func initialise_managers():
	# reminder to myla that handler is necessary for signals to be emitted/connected by the handler node (the one with this script)
	camera_manager = CameraManager.new(player)
	camera_manager.handler = self
	
	encounter_manager = EncounterManager.new(player, camera_manager, self.get_parent())
	encounter_manager.handler = self
	encounter_manager.set_monster_pool(monster_pool)
	encounter_manager.set_enemy_billboard_scene(enemy_billboard_scene)
	
	party_manager = PartyManager.new(active_party)
	party_manager.handler = self

func connect_signals():
	player.connect("tile_entered", self, "_on_tile_entered")

func _process(delta):
	if Input.is_action_just_pressed("debug_end_battle"):
		encounter_manager.end_encounter()

func _on_tile_entered(tile):
	encounter_manager.on_tile_entered(tile)
