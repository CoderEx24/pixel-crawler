extends CharacterBody2D

signal melee_hit(type: StringName)

enum MeleeWeaponState {
	IDLE,
	ATTACKING,
}

enum MeleeAttackType {
	WIDE,
	STAB
}

const TYPE = 'melee'
var _STATE = MeleeWeaponState.IDLE
var _KIND = MeleeAttackType.WIDE

func _ready() -> void:
	$AnimationPlayer.current_animation = 'idle'

func _physics_process(_delta: float) -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		print('\tWeapon - Collision with: ', collision)
		var collision_position = collision.get_position()
		var collider = collision.get_collider()
		
		if collider is not TileMapLayer:
			print('not a tile')
			continue
		
		var tilemap = collider as TileMapLayer
		var tilecoords = tilemap.local_to_map(collision_position)
		var tile = tilemap.get_cell_tile_data(tilecoords)
		var kind = tile.get_custom_data_by_layer_id(0)
		print('Collision of melee weapon with ', kind)

func _process(delta: float) -> void:
	pass
	
func attack(kind: MeleeAttackType) -> void:
	$AnimationPlayer.current_animation = 'attack'

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	$AnimationPlayer.current_animation = 'idle'
