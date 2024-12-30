extends CharacterBody2D

signal melee_hit(type: StringName)
signal tile_hit(type: String, coords: Vector2)

enum MeleeWeaponState {
	IDLE,
	ATTACKING,
	TIMED_OUT,
}

enum MeleeAttackType {
	BASE,
	STRONG
}

const TYPE = 'melee'
@export var BASE_DAMAGE = 12
var _state = MeleeWeaponState.IDLE
var _kind = MeleeAttackType.BASE
var _state_changed = false

func set_state(s: MeleeWeaponState):
	_state = s
	_state_changed = true

func _ready() -> void:
	pass

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
			emit_signal('tile_hit', kind, tilecoords)
			$Timeout.start()
		elif collider is CharacterBody2D:
			if collider is Enemy and _state == MeleeWeaponState.ATTACKING:
				var damage_multiplier = 1.2 if _kind == MeleeAttackType.STRONG else 1.0
				collider.deal_damage(BASE_DAMAGE * damage_multiplier)
				set_state(MeleeWeaponState.TIMED_OUT)
				$Timeout.start()
				
	move_and_slide()

func _process(delta: float) -> void:
	if not _state_changed:
		return
	
	_state_changed = false
	
	match _state:
		MeleeWeaponState.IDLE:
			$AnimationPlayer.play("idle")
			$CollisionArea.disabled = true
		MeleeWeaponState.ATTACKING:
			$CollisionArea.disabled = false
			match _kind:
				MeleeAttackType.BASE:
					$AnimationPlayer.play('base')
				MeleeAttackType.STRONG:
					$AnimationPlayer.play('strong')
		MeleeWeaponState.TIMED_OUT:
			$CollisionArea.disabled = true
	
	
func attack(kind: MeleeAttackType) -> void:
	_kind = kind
	set_state(MeleeWeaponState.ATTACKING)

func _on_timeout_timeout() -> void:
	set_state(MeleeWeaponState.IDLE)
	
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if _state == MeleeWeaponState.ATTACKING and anim_name in ['base', 'strong']:
		set_state(MeleeWeaponState.IDLE)
