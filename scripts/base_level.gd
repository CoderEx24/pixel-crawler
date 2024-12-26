extends Node2D

var hero: CharacterBody2D

func _ready() -> void:
	hero = GlobalGameState.instantiate_hero() if not EngineDebugger.is_active() \
		else load('res://scenes/core/knight.tscn').instantiate()
	hero.connect('entered_exit', _on_exit)
	hero.global_position = Vector2i(24, 18) * 2
	
	for enemy in get_tree().get_nodes_in_group('Enemies'):
		enemy.set_player(hero)
		enemy.connect('enemy_killed', _on_enemy_died)
	
	add_child(hero)

func _process(delta: float) -> void:
	pass
	
func _on_enemy_died():
	hero.score += 100
	
func _on_exit():
	get_tree().quit()
