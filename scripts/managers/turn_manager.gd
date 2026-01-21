extends Reference
class_name TurnManager

var handler: Node
var turn_order = []
var current_turn_index = 0

func set_turn_order(party_manager, encounter_manager):
	turn_order.clear()
	current_turn_index = 0
	
	for i in range(party_manager.active_party.size()):
		var monster = party_manager.active_party[i]
		turn_order.append({"monster": monster, "type": "party", "is_enemy": false, "party_index": i})
	
	for i in range(encounter_manager.encounters.size()):
		var monster = encounter_manager.encounters[i]
		turn_order.append({"entity": monster, "type": "enemy", "is_enemy": true, "monster": monster.monster, "enemy_index": i})

func get_current_actor():
	return turn_order[current_turn_index]

func advance_turn():
	current_turn_index += 1
	
	if current_turn_index >= turn_order.size():
		current_turn_index = 0
		handler.emit_signal("turn_cycle_complete")
	
	handler.emit_signal("turn_started", get_current_actor())

func remove_defeated(entity):
	for i in range(turn_order.size() - 1, -1, -1):
		if turn_order[i]["entity"] == entity:
			turn_order.remove(i)
			
			if current_turn_index >= turn_order.size():
				current_turn_index = 0
			
			if turn_order.empty():
				handler.emit_signal("battle_ended")
			break

func is_battle_over():
	var has_party = false
	var has_enemies = false
	
	for combatant in turn_order:
		if combatant["is_enemy"]:
			has_enemies = true
		else:
			has_party = true
	
	return not has_party or not has_enemies
