extends SceneTree
## Dev check: instantiate every region scene once to catch bad NodePaths,
## missing spawn markers, or broken ext_resource references that a plain
## editor import pass might not exercise.
## Run with: godot --headless --path . --script res://tools/validate_regions.gd
##
## Note: --script mode does not initialize autoloads, so scripts that
## reference GameManager/TimeManager/etc. will print SCRIPT ERROR compile
## noise here even when they're perfectly fine — Godot still builds the
## node structure without the script attached, so the structural checks
## below stay meaningful. Verify actual script correctness separately with
## `godot --headless --path . --editor --quit-after N` and a real
## `godot --headless --path . --quit-after N` run (autoloads included).

const REGIONS := [
	"res://world/Solenne/Foret_Aube/foret_aube.tscn",
	"res://world/Solenne/Boiselle/boiselle.tscn",
	"res://world/Solenne/Campi_Lucis/campi_lucis.tscn",
	"res://world/Solenne/Lac_Lune/lac_lune.tscn",
	"res://world/Solenne/Cite_Caelum/cite_caelum.tscn",
	"res://world/Solenne/Mont_Cieux/mont_cieux.tscn",
	"res://world/Solenne/Sanctuaire_Seuil/sanctuaire_seuil.tscn",
]


func _init() -> void:
	var ok := true
	for path in REGIONS:
		var packed: PackedScene = load(path)
		if packed == null:
			print("FAIL load: ", path)
			ok = false
			continue
		var instance: Node = packed.instantiate()
		if instance == null:
			print("FAIL instantiate: ", path)
			ok = false
			continue
		var spawn := instance.get_node_or_null("PlayerSpawn")
		if spawn == null:
			print("FAIL missing PlayerSpawn: ", path)
			ok = false
		for child in instance.get_children():
			if child is Area3D and child.get_script() and "target_scene_path" in child:
				var target: String = child.target_scene_path
				var spawn_name: String = String(child.target_spawn_point)
				if target == "":
					continue
				if not ResourceLoader.exists(target):
					print("FAIL transition target missing: ", path, " -> ", target)
					ok = false
					continue
				var target_packed: PackedScene = load(target)
				var target_instance: Node = target_packed.instantiate()
				if target_instance.get_node_or_null(spawn_name) == null:
					print("FAIL spawn point missing: ", target, " has no '", spawn_name, "' (referenced from ", path, ")")
					ok = false
				target_instance.free()
		instance.free()
	print("Region validation " + ("PASSED" if ok else "FAILED"))
	quit(0 if ok else 1)
