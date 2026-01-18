extends Control

export(NodePath) var handler_path

onready var tween = $Tween
onready var selection_grid = $Selection
onready var options = $Options
onready var handler = get_node(handler_path)

onready var default_position = Vector2(96, 238)
onready var encounter_position = Vector2(96, 158)

func _ready():
	self.rect_global_position = default_position
	handler.connect("battle_started", self, "on_battle_started")
	handler.connect("battle_ended", self, "on_battle_ended")
	handler.connect("update_active_party", selection_grid, "update_active_party")

func on_battle_started():
	tween.interpolate_property(self, "rect_global_position", rect_global_position, encounter_position, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.7)
	tween.start()

func on_battle_ended():
	tween.interpolate_property(self, "rect_global_position", rect_global_position, default_position, 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()
