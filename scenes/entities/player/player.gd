extends Spatial

signal tile_entered

onready var floor_cast = $FloorCast
onready var front_cast = $FrontCast
onready var back_cast = $BackCast
onready var animation_player = $AnimationPlayer

onready var travel_time = animation_player.get_animation("Bobbing").length

var camera_active: SceneTreeTween
var movement_locked = false

var direction_map = {
	"forward": Vector3.FORWARD,
	"back": Vector3.BACK,
	"left": Vector3.LEFT,
	"right": Vector3.RIGHT
}

var rotation_map = {
	"left": PI / 2,
	"right": -PI / 2
}

func _physics_process(delta):
	if movement_locked:
		return
	
	if camera_active and camera_active.is_running():
		return
	
	for input in direction_map.keys():
		if Input.is_action_pressed(input):
			var direction = direction_map[input]
			
			if rotation_map.has(input):
				rotate_by(rotation_map[input])
			else:
				var world_direction = transform.basis.xform(direction * 2)
				if not is_path_blocked(direction * 2, world_direction):
					move_to(world_direction)
					animation_player.play("Bobbing")
			break

func move_to(world_direction):
	camera_active = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	camera_active.tween_property(self, "global_transform:origin", global_transform.origin + world_direction, travel_time)
	camera_active.connect("finished", self, "on_movement_finished")

func on_movement_finished():
	floor_cast.translation = Vector3.ZERO
	floor_cast.cast_to = Vector3.DOWN * 3
	floor_cast.force_raycast_update()
	
	if floor_cast.is_colliding():
		var current_tile = floor_cast.get_collider()
		if current_tile:
			emit_signal("tile_entered", current_tile)

func rotate_by(angle):
	camera_active = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	camera_active.tween_property(self, "rotation:y", rotation.y + angle, travel_time)

func is_path_blocked(direction, world_direction):
	var chosen_raycast = null
	
	if direction == Vector3.FORWARD * 2:
		chosen_raycast = front_cast
	elif direction == Vector3.BACK * 2:
		chosen_raycast = back_cast
	
	if chosen_raycast:
		chosen_raycast.force_raycast_update()
		if chosen_raycast.is_colliding():
			return true
	
	var space_state = get_world().direct_space_state
	var target_position = global_transform.origin + world_direction
	
	return space_state.intersect_ray(target_position, target_position + Vector3.DOWN * 3).empty()

func get_forward_direction():
	var forward = -global_transform.basis.z
	forward.y = 0
	return forward.normalized()
