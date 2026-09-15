extends Control
## The Reality notebook: near-empty at first, fills in with discovered quest
## hints as the player explores. Never states outright that a quest failed —
## "le monde continue sans moi" is the point.

@onready var list: VBoxContainer = $Panel/VBox/List
@onready var loop_label: Label = $Panel/VBox/LoopLabel


func _ready() -> void:
	UIManager.register_panel(&"carnet_realite", self)
	UIManager.panel_opened.connect(_on_panel_opened)


func _on_panel_opened(panel_name: StringName) -> void:
	if panel_name == &"carnet_realite":
		refresh()


func refresh() -> void:
	loop_label.text = "Boucles vécues : %d" % LoopManager.loop_number
	for c in list.get_children():
		c.queue_free()
	if QuestManager.discovered_quests.is_empty():
		var lbl := Label.new()
		lbl.text = "Rien de notable pour l'instant. Explore."
		list.add_child(lbl)
		return
	for qid in QuestManager.discovered_quests:
		var q: QuestData = QuestManager.all_quests.get(qid)
		if q == null:
			continue
		var status := "résolue" if qid in QuestManager.completed_quests else "en cours"
		var lbl := RichTextLabel.new()
		lbl.fit_content = true
		lbl.bbcode_enabled = true
		lbl.text = "[b]%s[/b] (%s)\n%s" % [q.title, status, q.summary]
		list.add_child(lbl)
