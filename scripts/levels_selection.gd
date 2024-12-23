class_name LevelSelection
extends Control

@onready var level1_button = $MarginContainer/HBoxContainer/VBoxContainer/Level1_button as Button
@onready var level2_button = $MarginContainer/HBoxContainer/VBoxContainer/Level2_button as Button
@onready var level3_button = $MarginContainer/HBoxContainer/VBoxContainer/Level3_button as Button

@onready var start_level1 = preload("res://scenes/Level2.tscn") as PackedScene
@onready var start_level2 = preload("res://scenes/Level2.tscn") as PackedScene
@onready var start_level3 = preload("res://scenes/Level2.tscn") as PackedScene
func _ready():
	level1_button.button_down.connect(on_level1_pressed)
	level2_button.button_down.connect(on_level2_pressed)
	level3_button.button_down.connect(on_level3_pressed)


func on_level1_pressed()  -> void:
	get_tree().change_scene_to_packed(start_level1)
	
func on_level2_pressed() -> void:
	get_tree().change_scene_to_packed(start_level2)
	
func on_level3_pressed()  -> void:
	get_tree().change_scene_to_packed(start_level3)
