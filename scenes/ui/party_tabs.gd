extends GridContainer

onready var tab_scene = preload("res://scenes/ui/party_tab.tscn")

func update_active_party(active_party):
	for child in self.get_children():
		child.queue_free()
	
	for monster in active_party.size():
		var tab = tab_scene.instance()
		
		self.add_child(tab)
		tab.instanced(active_party[monster])
