extends Resource
class_name EndingData
## One possible ending. EndingManager evaluates these in priority order.

@export var id: StringName
@export var title: String
@export_multiline var description: String
@export var required_flags: Array[StringName] = []
@export var forbidden_flags: Array[StringName] = []
@export var priority: int = 0 # higher checked first (true ending should be highest)
@export var is_true_ending: bool = false
