extends CharacterBody2D

signal entered_exit

@export var SPEED: float = 300.0
@export var health_points: float = 100.0
var direction: Vector2i = Vector2i.ZERO
var attack

func _input(evt: InputEvent):
	
	if evt is InputEventKey:
		var go_right = evt.is_action_pressed('ui_right') || (direction.x == 1 and not evt.is_action_released('ui_right'))
		var go_left = evt.is_action_pressed('ui_left') || (direction.x == -1 and not evt.is_action_released('ui_left'))
		var go_up = evt.is_action_pressed('ui_up') || (direction.y == -1 and not evt.is_action_released('ui_up'))
		var go_down = evt.is_action_pressed('ui_down') || (direction.y == 1 and not evt.is_action_released('ui_down'))
	
		if go_left:
			direction.x = -1
		elif go_right:
			direction.x = 1
		else:
			direction.x = 0
		
		if go_up:
			direction.y = -1
		elif go_down:
			direction.y = 1
		else:
			direction.y = 0
		

func _physics_process(delta: float) -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collision_position = collision.get_position()
		var collider = collision.get_collider()
		
		if collider is not TileMapLayer:
			continue
		
		var tilemap = collider as TileMapLayer
		var tilecoords = tilemap.local_to_map(collision_position)
		var tile = tilemap.get_cell_tile_data(tilecoords)
		if not tile:
			continue

		var kind = tile.get_custom_data_by_layer_id(0)
		if kind and kind == 'exit':
			emit_signal('entered_exit')
			
	velocity = direction * SPEED
	move_and_slide()

func _process(delta):
	var animation = 'idle'
	if velocity.length() > 0:
		animation = 'run'
	
	if Input.is_key_pressed(KEY_K):
		$Weapon.attack($Weapon.MeleeAttackType.BASE)
	elif Input.is_key_pressed(KEY_J):
		$Weapon.attack($Weapon.MeleeAttackType.STRONG)
	
	$HeroSprite.play(animation)
	
	%HealthBar.value = lerp(%HealthBar.value, health_points, 0.1)

func recieve_damage(damage: float):
	health_points = max(0, health_points - damage)
	print('health points ', health_points)
