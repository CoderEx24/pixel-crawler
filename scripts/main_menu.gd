class_name MainMenu
extends Control

func _ready():
	pass
	
func _on_start_pressed() -> void:
	get_tree().change_scene_to_file('res://levels_selection.tscn')
	
func _on_exit_pressed()  -> void:
	get_tree().quit()
