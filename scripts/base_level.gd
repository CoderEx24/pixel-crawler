extends Node2D

class_name BaseLevel

@onready var KnightHero = preload("res://scenes/core/knight.tscn")

func _ready() -> void:
	var hero: CharacterBody2D = KnightHero.instantiate()
	hero.connect('entered_exit', _on_exit)
	hero.global_position = Vector2i(24, 18) * 2
	
	add_child(hero)

func _process(delta: float) -> void:
	pass
	
func _on_exit():
	get_tree().quit()
