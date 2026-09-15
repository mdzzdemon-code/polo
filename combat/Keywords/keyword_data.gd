extends Resource
class_name KeywordData
## A word the Anomaly can equip (max 3). Carries a conceptual meaning, not just a stat bonus.

@export var id: StringName
@export var display_name: String
@export var concept: String # one-line thematic meaning, shown in UI
@export_multiline var description: String
@export var damage_multiplier_vs_tag: float = 1.25
@export var vs_trauma_tag: StringName # matches a TraumaData.weaknesses entry
@export var dialogue_tag: StringName # unlocks/alters dialogue lines carrying this tag
