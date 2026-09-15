extends Node
## Autoload. Central place where a choice/quest outcome/death becomes a durable
## change to the world (a flag), instead of being scattered across every script
## that happens to witness it.

signal consequence_applied(flag: StringName)


func apply(flag: StringName, degradation_delta: int = 0) -> void:
	EventManager.set_flag(flag)
	if degradation_delta != 0:
		RealityManager.increase_degradation(degradation_delta)
	consequence_applied.emit(flag)
	EndingManager.trigger_if_ready()
