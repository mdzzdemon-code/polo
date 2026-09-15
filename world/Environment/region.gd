extends Node3D
class_name Region
## Attached to the root of every region scene (Foret_Aube, Boiselle, ...).
## Also the hook point for world degradation: the world starts beautiful and
## only visibly worsens as RealityManager.degradation_level climbs from real
## consequences (a death, a failed quest, a bad choice) — never on a timer.

@export var region_id: StringName
@export var ambient_music_path: String = ""
@export var ambience_sfx_path: String = ""

@onready var _world_environment: WorldEnvironment = get_node_or_null("WorldEnvironment")


func _ready() -> void:
	if ambient_music_path != "":
		AudioManager.play_music(ambient_music_path)
	EventManager.fire("region_entered", {"region": region_id})
	RealityManager.degradation_level_changed.connect(_apply_degradation)
	_apply_degradation(RealityManager.degradation_level)


func _apply_degradation(level: int) -> void:
	if _world_environment == null or _world_environment.environment == null:
		return
	var env := _world_environment.environment
	env.adjustment_enabled = true
	env.adjustment_saturation = clamp(1.0 - level * 0.12, 0.3, 1.0)
	env.adjustment_brightness = clamp(1.0 - level * 0.04, 0.75, 1.0)
	env.fog_enabled = level > 0
	if level > 0:
		env.fog_light_color = Color(0.5, 0.5, 0.55)
		env.fog_density = min(0.008 * level, 0.05)
