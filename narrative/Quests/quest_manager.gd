extends Node
## Autoload. Tracks quest availability/state without ever telling the player they
## missed something — the world just keeps moving. Journal UI reads discovered_quests.

signal quest_discovered(quest: QuestData)
signal quest_completed(quest: QuestData)
signal quest_failed(quest: QuestData)

var all_quests: Dictionary = {} # id -> QuestData, populated by register_quest()
var discovered_quests: Array[StringName] = []
var completed_quests: Array[StringName] = []
var failed_quests: Array[StringName] = []


func _ready() -> void:
	EventManager.flag_changed.connect(func(_f, _v): _reevaluate_all())
	TimeManager.hour_changed.connect(func(_h): _reevaluate_all())
	TimeManager.day_changed.connect(func(_d): _reevaluate_all())


func _reevaluate_all() -> void:
	# The world doesn't wait for the player to check a quest log — a window
	# closing or a failure flag firing silently fails it in the background.
	for qid in discovered_quests.duplicate():
		if qid in completed_quests or qid in failed_quests:
			continue
		var q: QuestData = all_quests.get(qid)
		if q == null:
			continue
		if EventManager.has_any_flag(q.failure_flags):
			fail(qid)
		elif TimeManager.day > q.available_until_day:
			fail(qid)
		elif TimeManager.day == q.available_until_day and TimeManager.hour() > q.available_until_hour:
			fail(qid)


func register_quest(quest: QuestData) -> void:
	all_quests[quest.id] = quest


func discover(quest_id: StringName) -> void:
	if quest_id in discovered_quests:
		return
	discovered_quests.append(quest_id)
	EventManager.set_flag("quest/%s/discovered" % quest_id)
	quest_discovered.emit(all_quests.get(quest_id))


func is_available(quest_id: StringName) -> bool:
	var q: QuestData = all_quests.get(quest_id)
	if q == null or quest_id in completed_quests or quest_id in failed_quests:
		return false
	if TimeManager.day < q.available_from_day or TimeManager.day > q.available_until_day:
		return false
	if TimeManager.hour() < q.available_from_hour or TimeManager.hour() > q.available_until_hour:
		return false
	if not EventManager.has_all_flags(q.required_flags):
		return false
	if EventManager.has_any_flag(q.failure_flags):
		fail(quest_id)
		return false
	return true


func complete(quest_id: StringName) -> void:
	if quest_id in completed_quests:
		return
	completed_quests.append(quest_id)
	EventManager.set_flag("quest/%s/completed" % quest_id)
	var q: QuestData = all_quests.get(quest_id)
	if q:
		if q.reward_memory_id != &"":
			MemoryManager.recover_memory(q.reward_memory_id)
		quest_completed.emit(q)


func fail(quest_id: StringName) -> void:
	if quest_id in failed_quests or quest_id in completed_quests:
		return
	failed_quests.append(quest_id)
	EventManager.set_flag("quest/%s/failed" % quest_id)
	quest_failed.emit(all_quests.get(quest_id))
