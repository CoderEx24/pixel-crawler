extends Node2D

func _ready() -> void:
	var hero: CharacterBody2D = GlobalGameState.instantiate_hero()
	hero.connect('entered_exit', _on_exit)
	hero.global_position = Vector2i(24, 18) * 2
	
	for enemy in get_tree().get_nodes_in_group('Enemies'):
		enemy.set_player(hero)
	
	add_child(hero)

func _process(delta: float) -> void:
	pass
	
func _on_exit():
	get_tree().quit()
