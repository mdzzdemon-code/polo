extends Control
## The Anomaly's own notebook: renders MemoryManager's current (possibly
## false, possibly illegible) understanding of each memory it holds.

@onready var list: VBoxContainer = $Panel/VBox/List


func _ready() -> void:
	UIManager.register_panel(&"carnet_anomalie", self)
	UIManager.panel_opened.connect(_on_panel_opened)
	MemoryManager.memory_recovered.connect(func(_id): refresh())
	MemoryManager.memory_lost.connect(func(_id): refresh())
	MemoryManager.memory_revealed.connect(func(_id): refresh())


func _on_panel_opened(panel_name: StringName) -> void:
	if panel_name == &"carnet_anomalie":
		refresh()


func refresh() -> void:
	for c in list.get_children():
		c.queue_free()
	if MemoryManager.possessed_memories.is_empty():
		var lbl := Label.new()
		lbl.text = "Le carnet est vide pour l'instant."
		list.add_child(lbl)
		return
	for id in MemoryManager.possessed_memories:
		var memory: MemoryData = MemoryManager.known_memories.get(id)
		if memory == null:
			continue
		var lbl := RichTextLabel.new()
		lbl.fit_content = true
		lbl.bbcode_enabled = true
		var status := " [illisible]" if MemoryManager.is_lost(id) else ""
		lbl.text = "[b]%s%s[/b]\n%s" % [memory.display_name, status, MemoryManager.carnet_text_for(id)]
		list.add_child(lbl)
