extends Resource
class_name EventData
## A scripted world event (e.g. Maëlle finds the fragment) that fires once its
## conditions are met and sets consequence flags in turn.

@export var id: StringName
@export_multiline var description: String
@export var required_flags: Array[StringName] = []
@export var forbidden_flags: Array[StringName] = []
@export var sets_flags: Array[StringName] = []
@export var triggers_glitch: bool = false
@export var once_per_loop: bool = true
