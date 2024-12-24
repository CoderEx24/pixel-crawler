extends Control

func _on_level_selection(level: StringName) -> void:
	var scene_name = 'res://scenes/levels/%s.tscn' % level
	get_tree().change_scene_to_file(scene_name)
