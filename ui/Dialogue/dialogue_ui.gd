extends Control

@onready var speaker_label: Label = $Panel/VBox/Speaker
@onready var text_label: RichTextLabel = $Panel/VBox/Text
@onready var choices_container: VBoxContainer = $Panel/VBox/Choices
@onready var continue_hint: Label = $Panel/VBox/ContinueHint

var _current_choices: Array[DialogueChoice] = []
var _e_was_down := false


func _ready() -> void:
	hide()
	DialogueManager.line_presented.connect(_on_line_presented)
	DialogueManager.dialogue_ended.connect(_on_dialogue_ended)


func _process(_delta: float) -> void:
	if not visible:
		return
	var down := Input.is_physical_key_pressed(KEY_E)
	if down and not _e_was_down and _current_choices.is_empty():
		DialogueManager.advance()
	_e_was_down = down


func _on_line_presented(_dialogue: DialogueData, line: DialogueLine, choices: Array[DialogueChoice]) -> void:
	show()
	_current_choices = choices
	speaker_label.text = line.speaker
	text_label.text = line.text
	for c in choices_container.get_children():
		c.queue_free()
	if choices.is_empty():
		continue_hint.show()
	else:
		continue_hint.hide()
		for choice in choices:
			var btn := Button.new()
			btn.text = choice.text
			btn.pressed.connect(_on_choice_pressed.bind(choice))
			choices_container.add_child(btn)


func _on_choice_pressed(choice: DialogueChoice) -> void:
	DialogueManager.choose(choice)


func _on_dialogue_ended() -> void:
	hide()
