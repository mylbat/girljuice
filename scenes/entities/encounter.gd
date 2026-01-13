extends Spatial

onready var billboard = $Billboard
onready var floor_cast = $FloorCast
onready var manipulation_player = $ManipulationPlayer

var monster = null
var current_frame = 0
var frame_timer = 0.0

func _ready():
	call_deferred("adjust_to_floor")

func _process(delta):
	if monster.frames > 1:
		animate_billboard(delta)

func adjust_to_floor():
	floor_cast.force_raycast_update()
	if floor_cast.is_colliding():
		self.global_transform.origin.y = floor_cast.get_collision_point().y + 0.5
		manipulation_player.play("Land")

func attribute_monster(resource):
	monster = resource
	
	var material = billboard.get_surface_material(0).duplicate()
	material.albedo_texture = monster.texture
	billboard.material_override = material
	update_uv_offset()

func animate_billboard(delta):
	frame_timer += delta
	if frame_timer >= 0.1:
		frame_timer -= 0.1
		current_frame = (current_frame + 1) % monster.frames
		update_uv_offset()

func update_uv_offset():
	var frame_width = 1.0 / monster.frames
	billboard.material_override.uv1_offset.x = current_frame * frame_width
	billboard.material_override.uv1_scale.x = frame_width
