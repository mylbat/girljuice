extends GridContainer

onready var tab_scene = preload("res://scenes/ui/party_tab.tscn")

var active_party_reference = []

func update_active_party(active_party):
	active_party_reference = active_party
	
	for child in self.get_children():
		child.queue_free()
	
	for monster in active_party.size():
		var tab = tab_scene.instance()
		
		self.add_child(tab)
		tab.instanced(active_party[monster])

func highlight_turn(party_member):
	var index = party_member["party_index"]
	
	if index == -1:
		return
	
	var tab_index = 0
	for child in self.get_children():
		if tab_index == index:
			child.set_active(true)
		else:
			child.set_active(false)
		
		tab_index += 1

func reset_all_tabs():
	for child in self.get_children():
		child.set_active(false)
