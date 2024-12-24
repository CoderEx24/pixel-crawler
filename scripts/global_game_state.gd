extends Node

var _selected_hero: String = ''

func _ready():
	pass

func select_hero(h: String):
	var hero = h.to_lower()
	assert(hero in ['knight', 'wizard', 'rogue'], 'Unknown hero type %s' % hero)
	
	_selected_hero = hero

func instantiate_hero():
	assert(_selected_hero in ['knight', 'wizard', 'rogue'], 'Unknown hero type %s' % _selected_hero)
	return load('res://scenes/core/%s.tscn' % _selected_hero).instantiate()

func selected_hero():
	return _selected_hero
