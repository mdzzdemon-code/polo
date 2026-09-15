extends Node
## Manages the Anomaly's equipped words: max 3 at once, pulled from a pool of
## keywords discovered through dialogue.

signal equipped_changed(equipped: Array[KeywordData])

const MAX_EQUIPPED := 3

var known_keywords: Array[KeywordData] = []
var equipped: Array[KeywordData] = []


func learn(keyword: KeywordData) -> void:
	if keyword in known_keywords:
		return
	known_keywords.append(keyword)
	EventManager.set_flag("keyword/%s/known" % keyword.id)


func equip(keyword: KeywordData) -> bool:
	if keyword in equipped or equipped.size() >= MAX_EQUIPPED:
		return false
	equipped.append(keyword)
	_notify()
	return true


func unequip(keyword: KeywordData) -> void:
	equipped.erase(keyword)
	_notify()


func equipped_tags() -> Array[StringName]:
	var tags: Array[StringName] = []
	for k in equipped:
		if k.dialogue_tag != &"":
			tags.append(k.dialogue_tag)
	return tags


func damage_multiplier_against(trauma_tags: Array[StringName]) -> float:
	var mult := 1.0
	for k in equipped:
		if k.vs_trauma_tag != &"" and k.vs_trauma_tag in trauma_tags:
			mult *= k.damage_multiplier_vs_tag
	return mult


func _notify() -> void:
	equipped_changed.emit(equipped)
	DialogueManager.update_keyword_tags(equipped_tags())
