extends ColorRect
## Full-screen flicker + SFX reacting to RealityManager glitches. Kept out of
## RealityManager itself so the "rules" system stays decoupled from
## presentation — this node is the one place glitches become audiovisual.

func _ready() -> void:
	color = Color(1, 1, 1, 0.0)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	RealityManager.glitch_triggered.connect(_on_glitch)


func _on_glitch(_glitch_id: StringName) -> void:
	AudioManager.play_sfx("glitch")
	color = Color(1, 1, 1, 0.35)
	var tween := create_tween()
	tween.tween_property(self, "color:a", 0.0, 0.25)
