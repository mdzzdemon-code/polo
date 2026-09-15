extends Node
## Placeholder for memory-bound abilities: unlocked/lost as MemoryManager gains
## or loses the corresponding memory (see MemoryData.unlocks_ability).

signal ability_unlocked(ability_id: StringName)
signal ability_lost(ability_id: StringName)

var unlocked_abilities: Array[StringName] = []


func _ready() -> void:
	MemoryManager.memory_recovered.connect(_on_memory_recovered)
	MemoryManager.memory_lost.connect(_on_memory_lost)


func has_ability(ability_id: StringName) -> bool:
	return ability_id in unlocked_abilities


func _on_memory_recovered(memory_id: StringName) -> void:
	var memory: MemoryData = MemoryManager.known_memories.get(memory_id)
	if memory and memory.unlocks_ability != &"" and not has_ability(memory.unlocks_ability):
		unlocked_abilities.append(memory.unlocks_ability)
		ability_unlocked.emit(memory.unlocks_ability)


func _on_memory_lost(memory_id: StringName) -> void:
	var memory: MemoryData = MemoryManager.known_memories.get(memory_id)
	if memory and memory.unlocks_ability != &"" and has_ability(memory.unlocks_ability):
		unlocked_abilities.erase(memory.unlocks_ability)
		ability_lost.emit(memory.unlocks_ability)
