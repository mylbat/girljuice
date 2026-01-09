extends Spatial

onready var billboard = $Billboard
onready var floor_cast = $FloorCast

var monster = null

func _ready():
	call_deferred("adjust_to_floor")

func adjust_to_floor():
	floor_cast.force_raycast_update()
	if floor_cast.is_colliding():
		self.global_transform.origin.y = floor_cast.get_collision_point().y + 0.5

func attribute_monster(resource):
	monster = resource

	var material = SpatialMaterial.new()
	material.flags_unshaded = true
	material.flags_transparent = true
	material.albedo_texture = monster.texture
	material.params_billboard_mode = SpatialMaterial.BILLBOARD_ENABLED
	
	billboard.material_override = material
