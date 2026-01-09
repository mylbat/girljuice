extends Spatial

onready var floor_cast = $FloorCast
onready var manipulation_player = $ManipulationPlayer

func _ready():
	call_deferred("adjust_to_floor")

func adjust_to_floor():
	floor_cast.force_raycast_update()
	if floor_cast.is_colliding():
		self.global_transform.origin.y = floor_cast.get_collision_point().y
	
	manipulation_player.play("Land")
