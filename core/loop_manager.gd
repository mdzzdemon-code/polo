extends Node
## Tracks the current loop number and drives loop start/end/reset (death, end
## of day 3, or a future voluntary reset). A loop always restarts the Anomaly
## at the forest — memories persist, the world and most items do not.

signal loop_started(loop_number: int)
signal loop_ended(loop_number: int, reason: String)

const LOOP_START_SCENE := "res://world/Solenne/Foret_Aube/foret_aube.tscn"

var loop_number: int = 1


func _ready() -> void:
	TimeManager.day_changed.connect(_on_day_changed)


func _on_day_changed(day: int) -> void:
	if day > 3:
		end_loop("day3_end")


func end_loop(reason: String = "natural") -> void:
	loop_ended.emit(loop_number, reason)
	MemoryManager.persist_across_loop()
	start_new_loop()


func start_new_loop() -> void:
	loop_number += 1
	TimeManager.reset_for_new_loop()
	EventManager.clear_loop_scoped_flags()
	var player := GameManager.player
	if player:
		player.health = player.max_health
		player.health_changed.emit(player.health, player.max_health)
		player.stability.reset()
		player.inventory.clear_loop_scoped_items()
	loop_started.emit(loop_number)
	GameManager.change_region(LOOP_START_SCENE)
