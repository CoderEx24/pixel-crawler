extends Control

func _on_level_selection(level: int) -> void:
	GlobalGameState.set_level(level)
