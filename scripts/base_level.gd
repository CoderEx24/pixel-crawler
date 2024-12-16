extends Node2D

class_name BaseLevel

@onready var KnightHero = preload("res://scenes/core/knight.tscn")
@onready var EnemyHero = preload('res://scenes/core/enemy.tscn')

func _ready() -> void:
	var hero: CharacterBody2D = KnightHero.instantiate()
	hero.connect('entered_exit', _on_exit)
	hero.global_position = Vector2i(24, 18) * 2
	
	var enemy: CharacterBody2D = EnemyHero.instantiate()
	enemy.global_position = Vector2i(24, 18) * 3
	
	add_child(hero)
	add_child(enemy)

func _process(delta: float) -> void:
	pass
	
func _on_exit():
	get_tree().quit()
