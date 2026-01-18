extends TextureRect

onready var info_panel = $Info
onready var member_name = $Info/Name

onready var hp_bar = $HitPointsBar
onready var hp_progress = $HitPointsBar/Progress
onready var hp_display = $HitPointsBar/Stat

onready var sp_bar = $SpecialPointsBar
onready var sp_progress = $SpecialPointsBar/Progress
onready var sp_display = $SpecialPointsBar/Stat

onready var tween = $Tween

onready var subject: MonsterSource

var is_active = false

func instanced(monster):
	subject = monster
	member_name.text = subject.name
	
	hp_progress.max_value = subject.hit_points
	hp_progress.value = subject.current_hp
	hp_display.text = str("%03d" % subject.current_hp)

func set_active(active):
	if active == is_active:
		return
	
	is_active = active
	if active:
		highlight()
	else:
		unhighlight()

func highlight():
	tween.interpolate_property(self, "rect_position:y", rect_position.y, rect_position.y - 10.0, 0.3, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()

func unhighlight():
	tween.interpolate_property(self, "rect_position:y", rect_position.y, 0.0, 0.3, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
