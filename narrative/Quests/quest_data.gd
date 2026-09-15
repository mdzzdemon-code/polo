extends Resource
class_name QuestData
## A quest that can be missed, time-gated, multi-solution, or resolved without combat.

@export var id: StringName
@export var title: String
@export_multiline var summary: String
@export var giver_character_id: StringName
@export var available_from_day: int = 1
@export var available_until_day: int = 3
@export var available_from_hour: int = 0
@export var available_until_hour: int = 24
@export var required_flags: Array[StringName] = [] # EventManager/consequence flags needed
@export var failure_flags: Array[StringName] = [] # flags that silently fail this quest
@export var reward_memory_id: StringName
@export var reward_item_ids: Array[StringName] = []
