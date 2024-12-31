extends CharacterBody2D

class_name Enemy

signal enemy_killed

enum EnemyState {
	CHASE,
	IDLE,
	WANDER,
	DEAD,
	ATTACK,
}

var player: CharacterBody2D
var SPEED = 30
@export var health_points = 100
@export var v: Vector2
var state: EnemyState = EnemyState.IDLE
var state_changed = false
var target_wander_position: Vector2

func set_state(s: EnemyState):
	if state == EnemyState.DEAD:
		return
	state = s
	state_changed = true

func set_player(p):
	player = p

func deal_damage(damage: int):
	health_points = max(0, health_points - damage)
	if health_points == 0:
		set_state(EnemyState.DEAD)
		return

func _ready():
	$Sprite2D.play('idle')
	$Weapon/AnimationPlayer.play('idle')
	$Weapon.connect('player_hit', _on_player_hit)
	
func _process(_delta: float) -> void:
	var mirror = sign(velocity.x) == -1
	
	$HealthPoints.value = health_points
	$Sprite2D.flip_h = mirror

	if not state_changed:
		return
	
	state_changed = false
	
	if state == EnemyState.CHASE:
		print('Enemy is Chasing')
		$Sprite2D.play('run')
		
		var idle_animation = 'idle_mirrored' if mirror else 'idle'
		$Weapon/AnimationPlayer.play(idle_animation)
		
	elif state == EnemyState.ATTACK:
		print('Enemy is Attacking')
		var attack_animation = 'attack_mirrored' if mirror else 'attack'
		$Weapon/AnimationPlayer.play(attack_animation)
		
	elif state == EnemyState.WANDER:
		print('Enemy is Wandering')
		$Sprite2D.play('run')
		
		var idle_animation = 'idle_mirrored' if mirror else 'idle'
		$Weapon/AnimationPlayer.play(idle_animation)

	elif state == EnemyState.IDLE:
		print('Enemy is Idling')
		$Sprite2D.play('idle')
		
		var idle_animation = 'idle_mirrored' if mirror else 'idle'
		$Weapon/AnimationPlayer.play(idle_animation)
		
	elif state == EnemyState.DEAD:
		print('Enemy is fucking dead')
		emit_signal('enemy_killed')
		$CollisionShape2D.disabled = true
		$VisiblityRegion/CollisionShape2D.disabled = true
		$AttackRegion/CollisionShape2D.disabled = true
		$Wander.stop()
		$Weapon.queue_free()
		$Sprite2D.play('death')
		$Kill.play()
		$Weapon/AnimationPlayer.stop()

func _physics_process(delta):
	match state:
		EnemyState.CHASE, EnemyState.ATTACK:
			var target = player.global_position
			var direction = (target - global_position).normalized() 
			var desired_velocity =  direction * SPEED
			var steering = (desired_velocity - velocity) * delta * 2.5
			velocity += steering
		EnemyState.WANDER:
			var displacement_vector = target_wander_position - global_position
			if displacement_vector.length() < 1:
				set_state(EnemyState.IDLE)
				return
			
			var desired_velocity = displacement_vector.normalized() * SPEED
			var steering = (desired_velocity - velocity) * delta * 2.5
			velocity += steering
		EnemyState.DEAD, EnemyState.IDLE:
			velocity = Vector2.ZERO
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()

	move_and_slide()

	
func _on_visiblity_region_body_entered(body: Node2D) -> void:
	if body.name == 'Hero' and state != EnemyState.DEAD:
		set_state(EnemyState.CHASE)

func _on_visiblity_region_body_exited(body: Node2D) -> void:
	if body.name == 'Hero' and state != EnemyState.DEAD:
		set_state(EnemyState.IDLE)

func _on_wander_timeout() -> void:
	match state:
		EnemyState.WANDER:
			set_state(EnemyState.IDLE)
		EnemyState.IDLE:
			set_state(EnemyState.WANDER)
			target_wander_position = \
				global_position + randi_range(0, 100) * Vector2.from_angle(randf_range(0, TAU))

	$Wander.start()

func _on_attack_region_body_entered(body: Node2D) -> void:
	if body.name == 'Hero':
		set_state(EnemyState.ATTACK)

func _on_attack_region_body_exited(body: Node2D) -> void:
	if body.name == 'Hero':
		set_state(EnemyState.CHASE)

func _on_player_hit(player: CharacterBody2D, points: float):
	player.recieve_damage(points)
