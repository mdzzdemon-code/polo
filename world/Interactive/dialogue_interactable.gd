extends Interactable
class_name DialogueInteractable
## For dialogue triggered by an object rather than an NPC (an altar, a sign,
## a note). Supports the same flag-gated variant selection as NPC.gd.

@export var dialogue: DialogueData
@export var dialogue_variants: Array[DialogueData] = []


func interact(_player: Player) -> void:
	var chosen: DialogueData = dialogue
	for variant in dialogue_variants:
		if EventManager.has_all_flags(variant.required_flags) and not EventManager.has_any_flag(variant.forbidden_flags):
			chosen = variant
			break
	if chosen:
		DialogueManager.start_dialogue(chosen)
