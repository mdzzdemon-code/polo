extends Node
## Autoload. The psychological/tactical thread between the Anomaly and the
## Traumas: tracks the player's dodge habits per Trauma id within a loop, so
## a Trauma that has "read" the player can punish the pattern instead of the
## fight being decided by stats alone.

const ANTICIPATION_THRESHOLD := 3

var dodge_habits: Dictionary = {} # trauma_id -> {"left": int, "right": int}


func record_dodge(trauma_id: StringName, direction: String) -> void:
	if direction != "left" and direction != "right":
		return
	if not dodge_habits.has(trauma_id):
		dodge_habits[trauma_id] = {"left": 0, "right": 0}
	dodge_habits[trauma_id][direction] += 1


## Returns "left"/"right" once the player has repeated a dodge direction
## often enough against this Trauma id, or "" if no reliable pattern yet.
func predicted_direction(trauma_id: StringName) -> String:
	var h: Dictionary = dodge_habits.get(trauma_id, {"left": 0, "right": 0})
	if h.left >= ANTICIPATION_THRESHOLD and h.left > h.right:
		return "left"
	if h.right >= ANTICIPATION_THRESHOLD and h.right > h.left:
		return "right"
	return ""


func has_been_understood(trauma_id: StringName) -> bool:
	return predicted_direction(trauma_id) != ""


func reset_for_loop() -> void:
	dodge_habits.clear()
