extends Control
## Inventory + keyword equip panel (I to toggle). The architecture doc doesn't
## give Keywords its own UI folder, so it lives here as a second column.

@onready var items_list: VBoxContainer = $Panel/HBox/Items/List
@onready var keywords_list: VBoxContainer = $Panel/HBox/Keywords/List
@onready var weapon_label: Label = $Panel/HBox/Items/WeaponLabel


func _ready() -> void:
	UIManager.register_panel(&"inventory", self)
	UIManager.panel_opened.connect(_on_panel_opened)


func _on_panel_opened(panel_name: StringName) -> void:
	if panel_name == &"inventory":
		refresh()


func refresh() -> void:
	var player: Player = GameManager.player
	if player == null:
		return

	for c in items_list.get_children():
		c.queue_free()
	for entry in player.inventory.slots.values():
		var lbl := Label.new()
		lbl.text = "%s x%d" % [entry.item.display_name, entry.quantity]
		items_list.add_child(lbl)

	if player.combat.equipped_weapon:
		weapon_label.text = "Arme : " + player.combat.equipped_weapon.display_name
	else:
		weapon_label.text = "Arme : aucune"

	for c in keywords_list.get_children():
		c.queue_free()
	for kw in player.keywords.known_keywords:
		var btn := Button.new()
		var is_equipped: bool = kw in player.keywords.equipped
		btn.text = ("[Équipé] " if is_equipped else "[ ] ") + kw.display_name + " — " + kw.concept
		btn.pressed.connect(_on_keyword_pressed.bind(kw))
		keywords_list.add_child(btn)
	if player.keywords.known_keywords.is_empty():
		var lbl := Label.new()
		lbl.text = "Aucun mot-clé appris pour l'instant."
		keywords_list.add_child(lbl)


func _on_keyword_pressed(kw: KeywordData) -> void:
	var player: Player = GameManager.player
	if kw in player.keywords.equipped:
		player.keywords.unequip(kw)
	else:
		player.keywords.equip(kw)
	refresh()
