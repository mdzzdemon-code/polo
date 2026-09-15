extends Node
## Autoload. Scans the content folders at boot and indexes every data Resource
## by its `id`, so dialogue/quests/etc. can grant things by StringName instead
## of holding direct references (keeps content files decoupled from each other).

var items: Dictionary = {}
var weapons: Dictionary = {}
var keywords: Dictionary = {}
var traumas: Dictionary = {}
var quests: Dictionary = {}
var memories: Dictionary = {}
var endings: Dictionary = {}
var characters: Dictionary = {}
var dialogues: Dictionary = {}


func _ready() -> void:
	_load_folder("res://narrative/Items")
	_load_folder("res://combat/Weapons")
	_load_folder("res://combat/Keywords")
	_load_folder("res://combat/Traumas")
	_load_folder("res://narrative/Quests")
	_load_folder("res://narrative/Memories")
	_load_folder("res://narrative/Endings")
	_load_folder("res://narrative/Characters")
	_load_folder("res://narrative/Dialogue/content")

	for q in quests.values():
		QuestManager.register_quest(q)
	for e in endings.values():
		EndingManager.register_ending(e)
	for m in memories.values():
		MemoryManager.register_memory(m)


func get_item(id: StringName) -> ItemData:
	return items.get(id)


func get_weapon(id: StringName) -> WeaponData:
	return weapons.get(id)


func get_keyword(id: StringName) -> KeywordData:
	return keywords.get(id)


func get_trauma(id: StringName) -> TraumaData:
	return traumas.get(id)


func get_quest(id: StringName) -> QuestData:
	return quests.get(id)


func get_memory(id: StringName) -> MemoryData:
	return memories.get(id)


func get_character(id: StringName) -> CharacterData:
	return characters.get(id)


func get_dialogue(id: StringName) -> DialogueData:
	return dialogues.get(id)


func _load_folder(path: String) -> void:
	var dir := DirAccess.open(path)
	if dir == null:
		return
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if file_name.ends_with(".tres"):
			var res: Resource = load(path + "/" + file_name)
			_register(res)
		file_name = dir.get_next()
	dir.list_dir_end()


func _register(res: Resource) -> void:
	if res is ItemData:
		items[res.id] = res
	elif res is WeaponData:
		weapons[res.id] = res
	elif res is KeywordData:
		keywords[res.id] = res
	elif res is TraumaData:
		traumas[res.id] = res
	elif res is QuestData:
		quests[res.id] = res
	elif res is MemoryData:
		memories[res.id] = res
	elif res is EndingData:
		endings[res.id] = res
	elif res is CharacterData:
		characters[res.id] = res
	elif res is DialogueData:
		dialogues[res.id] = res
