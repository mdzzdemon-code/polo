extends Node
## Drives in-world time: hour, day (1-3 within a loop), NPC schedules and time-gated events.
## One in-loop day ~= 45 real minutes (~2h15 per 3-day loop) at default speed, per the GDD.

signal hour_changed(hour: int)
signal day_changed(day: int)

const MINUTES_PER_DAY := 24 * 60
const REAL_SECONDS_PER_IN_GAME_MINUTE := 1.875 # 45 real min <=> 1440 in-game min (1 day)

var day: int = 1 # 1..3 within the current loop
var minute_of_day: int = 8 * 60 # start at 08:00
var time_scale: float = 1.0
var paused: bool = false


func _process(delta: float) -> void:
	if paused:
		return
	var prev_hour := hour()
	minute_of_day += (delta / REAL_SECONDS_PER_IN_GAME_MINUTE) * time_scale
	if minute_of_day >= MINUTES_PER_DAY:
		minute_of_day -= MINUTES_PER_DAY
		day += 1
		day_changed.emit(day)
	if hour() != prev_hour:
		hour_changed.emit(hour())


func hour() -> int:
	return int(minute_of_day / 60.0) % 24


func reset_for_new_loop() -> void:
	day = 1
	minute_of_day = 8 * 60
