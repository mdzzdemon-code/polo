extends Node
## Tracks the current loop number and drives loop start/end/reset (death, voluntary reset, natural end).

signal loop_started(loop_number: int)
signal loop_ended(loop_number: int)

var loop_number: int = 1


func start_new_loop() -> void:
	loop_number += 1
	TimeManager.reset_for_new_loop()
	loop_started.emit(loop_number)


func end_loop(reason: String = "natural") -> void:
	loop_ended.emit(loop_number)
	MemoryManager.persist_across_loop()
	start_new_loop()
