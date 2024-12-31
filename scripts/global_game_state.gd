extends Node

var _selected_hero: String = 'knight'
var _current_level = 1
const MAX_LEVEL_COUNT = 2

func _ready():
	pass

func select_hero(h: String):
	var hero = h.to_lower()
	assert(hero in ['knight', 'wizard', 'rogue'], 'Unknown hero type %s' % hero)
	
	_selected_hero = hero

func instantiate_hero():
	if _selected_hero not in ['knight', 'wizard', 'rogue']:
		printerr('Unknown hero type %s' % _selected_hero)
	
	return load('res://scenes/core/hero.tscn').instantiate()

func selected_hero():
	return _selected_hero
	
func advance_to_next_level():
	_current_level += 1
	if _current_level > MAX_LEVEL_COUNT:
		get_tree().quit()
		
	get_tree().change_scene_to_file('res://scenes/levels/L%d.tscn' % _current_level)
