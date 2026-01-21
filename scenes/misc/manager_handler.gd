extends Node

signal battle_started
signal battle_ended
signal update_active_party
signal turn_started
signal turn_changed
signal turn_cycle_complete

export(NodePath) var player_path
export(PackedScene) var enemy_billboard_scene
export(Array, Resource) var monster_pool
export(Array, Resource) var active_party

onready var camera_manager: CameraManager
onready var encounter_manager: EncounterManager
onready var party_manager: PartyManager

onready var player = get_node(player_path)

var current_turn_actor = null

func _ready():
	initialise_managers()
	connect_signals()
	
	yield(self.get_tree(), "idle_frame")
	self.emit_signal("update_active_party", party_manager.active_party)

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
	player.connect("tile_entered", self, "on_tile_entered")
	self.connect("turn_started", self, "on_turn_started")

func _process(delta):
	if Input.is_action_just_pressed("debug_end_battle"):
		encounter_manager.end_encounter()
	
	if Input.is_action_just_pressed("ui_accept") and encounter_manager.is_battle_active():
		encounter_manager.turn_manager.advance_turn()

func on_tile_entered(tile):
	encounter_manager.on_tile_entered(tile)

func on_turn_started(actor):
	current_turn_actor = actor
	print(actor["monster"].name,"'s turn")
