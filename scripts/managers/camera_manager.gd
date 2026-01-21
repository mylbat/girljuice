extends Reference
class_name CameraManager

var handler: Node
var player: Node
var camera: Camera
var original_fov = 70.0
var original_translation = Vector3.ZERO
var transition_time = 0.5

var in_battle = false

func _init(player_node):
	player = player_node
	camera = player.get_child(0)
	original_fov = camera.fov
	original_translation = camera.translation

func battle_start():
	if in_battle:
		return
	
	in_battle = true
	
	player.get_child(5).play("Battle Transition")

func battle_end():
	if not in_battle:
		return
	
	in_battle = false
	
	var tween = camera.create_tween().set_parallel(true).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.tween_property(camera, "fov", original_fov, transition_time)
	tween.tween_property(camera, "translation", original_translation, transition_time)
	tween.tween_callback(self, "on_battle_ended")

func on_battle_ended():
	player.movement_locked = false
