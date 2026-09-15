extends Node
## Autoload. Walks a DialogueData tree, gating lines/choices on EventManager flags
## and on the player's currently equipped keyword tags. UI listens to its signals.

signal line_presented(dialogue: DialogueData, line: DialogueLine, choices: Array[DialogueChoice])
signal dialogue_ended

var current_dialogue: DialogueData
var current_line: DialogueLine
var player_keyword_tags: Array[StringName] = []


func update_keyword_tags(tags: Array[StringName]) -> void:
	player_keyword_tags = tags


func start_dialogue(data: DialogueData) -> void:
	if data == null or data.lines.is_empty():
		return
	current_dialogue = data
	GameManager.set_mode(GameManager.Mode.DIALOGUE)
	_show_line(data.first_valid_start_line())


func advance() -> void:
	if current_line == null:
		return
	if current_line.auto_next_line_id != &"":
		_show_line(current_dialogue.find_line(current_line.auto_next_line_id))
	else:
		end_dialogue()


func choose(choice: DialogueChoice) -> void:
	for f in choice.sets_flags:
		EventManager.set_flag(f)
	_apply_effects(choice.grants_item_id, choice.grants_keyword_id, choice.starts_quest_id)
	if choice.ends_dialogue or choice.target_line_id == &"":
		end_dialogue()
	else:
		_show_line(current_dialogue.find_line(choice.target_line_id))


func end_dialogue() -> void:
	current_dialogue = null
	current_line = null
	GameManager.set_mode(GameManager.Mode.EXPLORATION)
	dialogue_ended.emit()


func _show_line(line: DialogueLine) -> void:
	if line == null or not _flags_ok(line.required_flags, line.forbidden_flags):
		end_dialogue()
		return
	current_line = line
	for f in line.sets_flags:
		EventManager.set_flag(f)
	_apply_effects(line.grants_item_id, line.grants_keyword_id, line.starts_quest_id)
	if line.triggers_glitch:
		RealityManager.trigger_glitch(line.line_id)
	var valid_choices: Array[DialogueChoice] = []
	for c in line.choices:
		if _choice_ok(c):
			valid_choices.append(c)
	line_presented.emit(current_dialogue, line, valid_choices)


func _flags_ok(required: Array[StringName], forbidden: Array[StringName]) -> bool:
	return EventManager.has_all_flags(required) and not EventManager.has_any_flag(forbidden)


func _apply_effects(item_id: StringName, keyword_id: StringName, quest_id: StringName) -> void:
	var player: Player = GameManager.player
	if item_id != &"" and player:
		var item := ContentRegistry.get_item(item_id)
		if item:
			player.inventory.add_item(item)
	if keyword_id != &"" and player:
		var keyword := ContentRegistry.get_keyword(keyword_id)
		if keyword:
			player.keywords.learn(keyword)
	if quest_id != &"":
		QuestManager.discover(quest_id)


func _choice_ok(choice: DialogueChoice) -> bool:
	if not _flags_ok(choice.required_flags, choice.forbidden_flags):
		return false
	if choice.required_keyword_tag != &"" and not (choice.required_keyword_tag in player_keyword_tags):
		return false
	return true
