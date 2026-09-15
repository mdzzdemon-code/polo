extends Resource
class_name DialogueData
## A full dialogue tree for one conversation.

@export var id: StringName
@export var start_line_id: StringName
@export var lines: Array[DialogueLine] = []


func find_line(line_id: StringName) -> DialogueLine:
	for line in lines:
		if line.line_id == line_id:
			return line
	return null


func first_valid_start_line() -> DialogueLine:
	# Walks lines in order, honoring conditions, so a dialogue resource can offer
	# several possible openings (e.g. a "first meeting" vs "already met" variant).
	for line in lines:
		if line.line_id == start_line_id:
			return line
	return lines[0] if not lines.is_empty() else null
