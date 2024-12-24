extends Control

func _on_hero_selection(hero: String):
	GlobalGameState.select_hero(hero)
	get_tree().change_scene_to_file('res://scenes/levels_selection.tscn')
