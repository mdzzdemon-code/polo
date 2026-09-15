extends Resource
class_name DialogueChoice
## One branch out of a DialogueLine. Only shown when its conditions are met.

@export_multiline var text: String
@export var target_line_id: StringName
@export var required_flags: Array[StringName] = []
@export var forbidden_flags: Array[StringName] = []
@export var sets_flags: Array[StringName] = []
@export var grants_item_id: StringName
@export var grants_keyword_id: StringName
@export var starts_quest_id: StringName
@export var completes_quest_id: StringName
@export var required_keyword_tag: StringName # gated by an equipped KeywordData.dialogue_tag
@export var ends_dialogue: bool = false
