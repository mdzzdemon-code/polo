extends Resource
class_name DialogueLine
## One line of dialogue. Either auto-advances to auto_next_line_id, or presents choices.

@export var line_id: StringName
@export var speaker: String
@export_multiline var text: String
@export var required_flags: Array[StringName] = []
@export var forbidden_flags: Array[StringName] = []
@export var sets_flags: Array[StringName] = [] # applied as soon as this line is shown
@export var grants_item_id: StringName # optional ItemData id auto-added to inventory
@export var grants_keyword_id: StringName # optional KeywordData id learned
@export var starts_quest_id: StringName # optional QuestData id marked discovered
@export var completes_quest_id: StringName
@export var triggers_glitch: bool = false
@export var auto_next_line_id: StringName
@export var choices: Array[DialogueChoice] = []
