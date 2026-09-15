extends Control

@onready var title_label: Label = $Panel/VBox/Title
@onready var text_label: RichTextLabel = $Panel/VBox/Text


func _ready() -> void:
	hide()
	EndingManager.ending_reached.connect(_on_ending_reached)


func _on_ending_reached(ending: EndingData) -> void:
	title_label.text = ending.title
	text_label.text = ending.description
	GameManager.set_mode(GameManager.Mode.CUTSCENE)
	show()
