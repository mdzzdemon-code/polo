extends Node
## Autoload. Mutual-exclusion coordinator for the toggleable menu panels
## (Inventory, Carnet de l'Anomalie, Carnet de Réalité, pause...) so opening
## one closes any other and correctly flips GameManager's mode.

signal panel_opened(panel_name: StringName)
signal panel_closed

var current_panel: StringName = &""
var panels: Dictionary = {} # StringName -> Control


func register_panel(panel_name: StringName, node: Control) -> void:
	panels[panel_name] = node
	node.hide()


func toggle(panel_name: StringName) -> void:
	if current_panel == panel_name:
		close()
	else:
		open(panel_name)


func open(panel_name: StringName) -> void:
	if current_panel != &"" and panels.has(current_panel):
		panels[current_panel].hide()
	current_panel = panel_name
	if panels.has(panel_name):
		panels[panel_name].show()
	GameManager.set_mode(GameManager.Mode.MENU)
	panel_opened.emit(panel_name)


func close() -> void:
	if current_panel != &"" and panels.has(current_panel):
		panels[current_panel].hide()
	current_panel = &""
	GameManager.set_mode(GameManager.Mode.EXPLORATION)
	panel_closed.emit()


func is_open() -> bool:
	return current_panel != &""
