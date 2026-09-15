extends Node
## Persists what should survive between sessions: loop count, degradation,
## every world flag, memory/quest state, and the player's carried-over
## keywords/inventory/position. Auto-saves on every loop transition and
## ending, plus F5/F9 for manual save/load (see MenuHotkeys).

const SAVE_PATH := "user://save.dat"


func save_game() -> void:
	var data := {
		"loop_number": LoopManager.loop_number,
		"degradation_level": RealityManager.degradation_level,
		"flags": _flags_to_json(EventManager.get_all_flags()),
		"lost_memories": _to_str_array(MemoryManager.lost_memories),
		"revealed_memories": _to_str_array(MemoryManager.revealed_memories),
		"discovered_quests": _to_str_array(QuestManager.discovered_quests),
		"completed_quests": _to_str_array(QuestManager.completed_quests),
		"failed_quests": _to_str_array(QuestManager.failed_quests),
		"region": GameManager.current_region_path,
	}
	var player := GameManager.player
	if player:
		data["player"] = _serialize_player(player)

	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return
	file.store_string(JSON.stringify(data))
	file.close()


func load_game() -> bool:
	if not FileAccess.file_exists(SAVE_PATH):
		return false
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var text := file.get_as_text()
	file.close()

	var data = JSON.parse_string(text)
	if typeof(data) != TYPE_DICTIONARY:
		return false

	LoopManager.loop_number = data.get("loop_number", 1)
	RealityManager.degradation_level = data.get("degradation_level", 0)
	EventManager.load_flags(data.get("flags", {}))
	MemoryManager.lost_memories = _to_sn_array(data.get("lost_memories", []))
	MemoryManager.revealed_memories = _to_sn_array(data.get("revealed_memories", []))
	QuestManager.discovered_quests = _to_sn_array(data.get("discovered_quests", []))
	QuestManager.completed_quests = _to_sn_array(data.get("completed_quests", []))
	QuestManager.failed_quests = _to_sn_array(data.get("failed_quests", []))

	var region: String = data.get("region", LoopManager.LOOP_START_SCENE)
	if region != "" and ResourceLoader.exists(region):
		GameManager.change_region(region)

	var pdata = data.get("player")
	var player := GameManager.player
	if pdata != null and player:
		_deserialize_player(player, pdata)
	return true


func _serialize_player(player: Player) -> Dictionary:
	var known: Array = []
	for kw in player.keywords.known_keywords:
		known.append(String(kw.id))
	var equipped: Array = []
	for kw in player.keywords.equipped:
		equipped.append(String(kw.id))
	var inventory: Array = []
	for entry in player.inventory.slots.values():
		inventory.append({"id": String(entry.item.id), "quantity": entry.quantity})
	var pos := player.global_position
	return {
		"health": player.health,
		"max_health": player.max_health,
		"position": [pos.x, pos.y, pos.z],
		"rotation_y": player.rotation.y,
		"known_keywords": known,
		"equipped_keywords": equipped,
		"inventory": inventory,
		"weapon": String(player.combat.equipped_weapon.id) if player.combat.equipped_weapon else "",
	}


func _deserialize_player(player: Player, pdata: Dictionary) -> void:
	player.max_health = pdata.get("max_health", player.max_health)
	player.health = pdata.get("health", player.health)
	player.health_changed.emit(player.health, player.max_health)

	var pos: Array = pdata.get("position", [0.0, 0.0, 0.0])
	if pos.size() == 3:
		player.global_position = Vector3(pos[0], pos[1], pos[2])
	player.rotation.y = pdata.get("rotation_y", 0.0)

	for kw_id in pdata.get("known_keywords", []):
		var kw := ContentRegistry.get_keyword(StringName(kw_id))
		if kw:
			player.keywords.learn(kw)
	for kw_id in pdata.get("equipped_keywords", []):
		var kw := ContentRegistry.get_keyword(StringName(kw_id))
		if kw:
			player.keywords.equip(kw)
	for item_entry in pdata.get("inventory", []):
		var item := ContentRegistry.get_item(StringName(item_entry.get("id", "")))
		if item:
			player.inventory.add_item(item, item_entry.get("quantity", 1))
	var weapon_id: String = pdata.get("weapon", "")
	if weapon_id != "":
		var weapon := ContentRegistry.get_weapon(StringName(weapon_id))
		if weapon:
			player.combat.equipped_weapon = weapon


func _flags_to_json(flags: Dictionary) -> Dictionary:
	var out := {}
	for k in flags.keys():
		out[String(k)] = flags[k]
	return out


func _to_str_array(arr: Array) -> Array:
	var out: Array = []
	for v in arr:
		out.append(String(v))
	return out


func _to_sn_array(arr: Array) -> Array[StringName]:
	var out: Array[StringName] = []
	for v in arr:
		out.append(StringName(v))
	return out
