extends Area3D
class_name GlitchTrigger
## A subtle, mostly-invisible trigger volume: the player walking through it
## fires a glitch. Used for the opening forest's "did I really see that?" beats.

@export var glitch_id: StringName
@export var once: bool = true

var _fired: bool = false


func _ready() -> void:
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("player"):
		return
	if once and _fired:
		return
	_fired = true
	RealityManager.trigger_glitch(glitch_id)
