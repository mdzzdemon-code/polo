extends Node
## Owns the Anomaly's memories: known, lost, recovered, false, and dangerous memories,
## plus what persists across loops (memories persist; inventory generally does not).

signal memory_lost(memory_id: StringName)
signal memory_recovered(memory_id: StringName)

var known_memories: Dictionary = {} # memory_id -> MemoryData resource
var lost_memories: Array[StringName] = []
var false_memories: Array[StringName] = []


func lose_memory(memory_id: StringName) -> void:
	if memory_id in known_memories:
		lost_memories.append(memory_id)
		memory_lost.emit(memory_id)


func recover_memory(memory_id: StringName) -> void:
	lost_memories.erase(memory_id)
	memory_recovered.emit(memory_id)


func persist_across_loop() -> void:
	# Memories carry over between loops; equipment/inventory does not (see SaveManager).
	pass
