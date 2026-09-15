extends Node
## Handles persistence: what survives a loop reset (memories, the Carnet de Réalité,
## discovered lore) versus what is scoped to the current loop (inventory, quest progress).

const SAVE_PATH := "user://save.dat"


func save_game() -> void:
	pass


func load_game() -> void:
	pass
