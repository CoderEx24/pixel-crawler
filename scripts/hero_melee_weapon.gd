extends Node2D

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

func _process(delta: float) -> void:
	pass
	
func attack(kind: MeleeAttackType) -> void:
	$AnimationPlayer.current_animation = 'attack'

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	print('finished animation ', anim_name)
	$AnimationPlayer.current_animation = 'idle'
