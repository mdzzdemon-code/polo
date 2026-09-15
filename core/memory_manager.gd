extends Node
## Owns the Anomaly's memories: known, lost, recovered, false, and dangerous memories,
## plus what persists across loops (memories persist; inventory generally does not).
## This is the system the Carnet de l'Anomalie renders from.

signal memory_lost(memory_id: StringName)
signal memory_recovered(memory_id: StringName)
signal memory_revealed(memory_id: StringName)

var known_memories: Dictionary = {} # memory_id -> MemoryData, the full registry (ContentRegistry fills this)
var possessed_memories: Array[StringName] = [] # memories the Anomaly currently holds — this is what the Carnet renders
var lost_memories: Array[StringName] = []
var revealed_memories: Array[StringName] = [] # true_text has been unlocked for these

## The Anomaly starts with artificially-provided memories that are actually
## false (GDD §1) — everything else is earned through play.
const STARTING_MEMORY_IDS: Array[StringName] = [&"souvenir_enfance_fausse"]


func _ready() -> void:
	for id in STARTING_MEMORY_IDS:
		if not (id in possessed_memories):
			possessed_memories.append(id)


func register_memory(memory: MemoryData) -> void:
	known_memories[memory.id] = memory


func lose_memory(memory_id: StringName) -> void:
	if memory_id in possessed_memories and not (memory_id in lost_memories):
		lost_memories.append(memory_id)
		memory_lost.emit(memory_id)


func recover_memory(memory_id: StringName) -> void:
	if not (memory_id in possessed_memories):
		possessed_memories.append(memory_id)
	lost_memories.erase(memory_id)
	memory_recovered.emit(memory_id)
	EventManager.set_flag("memory/%s/recovered" % memory_id)


func reveal_true_memory(memory_id: StringName) -> void:
	if memory_id in revealed_memories:
		return
	revealed_memories.append(memory_id)
	EventManager.set_flag("memory/%s/revealed" % memory_id)
	memory_revealed.emit(memory_id)


func carnet_text_for(memory_id: StringName) -> String:
	var memory: MemoryData = known_memories.get(memory_id)
	if memory == null:
		return ""
	if memory_id in lost_memories:
		return "[...souvenir illisible...]"
	if memory_id in revealed_memories:
		return memory.true_text
	return memory.carnet_anomalie_text


func is_lost(memory_id: StringName) -> bool:
	return memory_id in lost_memories


func persist_across_loop() -> void:
	# Memories (known/lost/revealed) carry over between loops as-is; nothing to do here —
	# this function exists so the intent is explicit at the LoopManager call site,
	# and as the hook for a future "sacrifice a random memory" mechanic.
	pass


func sacrifice_random_memory() -> StringName:
	var candidates: Array = []
	for id in possessed_memories:
		if not (id in lost_memories):
			candidates.append(id)
	if candidates.is_empty():
		return &""
	var chosen: StringName = candidates[randi() % candidates.size()]
	lose_memory(chosen)
	return chosen
