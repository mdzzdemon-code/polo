extends Node2D
class_name Region
## Attached to the root of every region scene (Foret_Aube, Boiselle, ...).
## Also the hook point for world degradation: the world starts beautiful and
## only visibly worsens as RealityManager.degradation_level climbs from real
## consequences (a death, a failed quest, a bad choice) — never on a timer.

@export var region_id: StringName
@export var ambient_music_path: String = ""
@export var ambience_sfx_path: String = ""

@onready var _canvas_modulate: CanvasModulate = get_node_or_null("CanvasModulate")

const DEGRADED_TINT := Color(0.55, 0.55, 0.6)


func _ready() -> void:
	if ambient_music_path != "":
		AudioManager.play_music(ambient_music_path)
	EventManager.fire("region_entered", {"region": region_id})
	RealityManager.degradation_level_changed.connect(_apply_degradation)
	_apply_degradation(RealityManager.degradation_level)


func _apply_degradation(level: int) -> void:
	if _canvas_modulate == null:
		return
	var t: float = clamp(float(level) / 5.0, 0.0, 1.0)
	_canvas_modulate.color = Color.WHITE.lerp(DEGRADED_TINT, t)
