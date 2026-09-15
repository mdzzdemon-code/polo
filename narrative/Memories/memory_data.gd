extends Resource
class_name MemoryData
## A memory fragment: narrative + mechanical value, can be true or false, can be lost/recovered.

@export var id: StringName
@export var display_name: String
@export_multiline var carnet_anomalie_text: String # what the Anomaly's notebook currently says
@export_multiline var true_text: String # the real content, revealed once the true source is found
@export var is_false_memory: bool = false
@export var source_hint: String # vague clue toward where the true memory can be recovered
@export var unlocks_ability: StringName # optional AbilityData id restored when recovered
