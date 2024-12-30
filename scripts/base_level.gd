extends Node2D

var hero: CharacterBody2D
const WEAPONS = [
	'wooden_sword',
	'wooden_axe',
]


func _ready() -> void:
	hero = GlobalGameState.instantiate_hero() if not EngineDebugger.is_active() \
		else load('res://scenes/core/knight.tscn').instantiate()
	hero.connect('entered_exit', _on_exit)
	hero.global_position = Vector2i(24, 18) * 2
	hero.connect('tile_hit', _on_tile_hit)
	hero.name = 'Hero'
	
	for enemy in get_tree().get_nodes_in_group('Enemies'):
		enemy.set_player(hero)
		enemy.connect('enemy_killed', _on_enemy_died)
	
	add_child(hero)

func _process(delta: float) -> void:
	pass
	
func _on_tile_hit(kind: String, coords: Vector2):
	print('hit ', kind, ' at ', coords)
	match kind:
		'crate':
			$Props.set_cell(coords, 0, Vector2(3, 13))
			$Props.set_cell(coords + Vector2.UP, 0, Vector2(3, 12))
			
			var collectable_position = $Props.to_global(
				$Props.map_to_local(coords + 2 * Vector2.UP + 2 * Vector2.RIGHT)
			)
			var collectable = preload('res://scenes/core/collectable.tscn').instantiate()
			collectable.global_position = collectable_position
			collectable.connect('collected', _on_collectable_collected)
			
			add_child(collectable)
	

func _on_collectable_collected(collectable: String):
	print('collected ', collectable)
	
	if collectable in WEAPONS:
		$Hero.change_weapon(collectable)

func _on_enemy_died():
	hero.score += 100
	
func _on_exit():
	get_tree().quit()
