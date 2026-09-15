extends Node3D
class_name Region
## Attached to the root of every region scene (Foret_Aube, Boiselle, ...).

@export var region_id: StringName
@export var ambient_music_path: String = ""
@export var ambience_sfx_path: String = ""


func _ready() -> void:
	if ambient_music_path != "":
		AudioManager.play_music(ambient_music_path)
	EventManager.fire("region_entered", {"region": region_id})
