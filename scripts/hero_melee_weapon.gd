extends CharacterBody2D

signal melee_hit(type: StringName)

enum MeleeWeaponState {
	IDLE,
	ATTACKING,
}

enum MeleeAttackType {
	BASE,
	STRONG
}

const TYPE = 'melee'
@export var BASE_DAMAGE = 12
var _STATE = MeleeWeaponState.IDLE
var _KIND = MeleeAttackType.BASE

func _ready() -> void:
	$AnimationPlayer.current_animation = 'idle'
	$CollisionArea.disabled = true

func _physics_process(_delta: float) -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collision_position = collision.get_position()
		var collider = collision.get_collider()
		
		if collider is TileMapLayer:
			var tilemap = collider as TileMapLayer
			var tilecoords = tilemap.local_to_map(collision_position)
			var tile = tilemap.get_cell_tile_data(tilecoords)
			if not tile:
				continue

			var kind = tile.get_custom_data_by_layer_id(0)
		elif collider is CharacterBody2D:
			if collider is Enemy:
				var damage_multiplier = 1.2 if _KIND == MeleeAttackType.STRONG else 1.0
				collider.deal_damage(BASE_DAMAGE * damage_multiplier)
	move_and_slide()

func _process(delta: float) -> void:
	pass
	
func attack(kind: MeleeAttackType) -> void:
	_KIND = kind
	match kind:
		MeleeAttackType.STRONG:
			$AnimationPlayer.play('strong')
		MeleeAttackType.BASE:
			$AnimationPlayer.play('base')

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	$AnimationPlayer.play('idle')
	$CollisionArea.disabled = true
