extends CharacterBody2D

class_name Enemy

enum EnemyState {
	CHASE,
	IDLE,
	WANDER,
	DEAD,
}

var player: CharacterBody2D
var SPEED = 30
@export var health_points = 100
@export var v: Vector2
var state: EnemyState = EnemyState.IDLE
var target_wander_position: Vector2

func set_player(p):
	player = p

func deal_damage(damage: int):
	health_points = max(0, health_points - damage)
	if health_points == 0:
		_die()
		return
	$CollisionShape2D.disabled = true
	$Stuned.start()

func _ready():
	$Sprite2D.play('idle')
	
func _process(_delta: float) -> void:
	$HealthPoints.value = health_points
	$Sprite2D.flip_h = sign(velocity.x) == -1

	if state != EnemyState.DEAD:
		$Sprite2D.pause()
	
	if state == EnemyState.CHASE or state == EnemyState.WANDER:
		$Sprite2D.play('run')
	elif state == EnemyState.IDLE:
		$Sprite2D.play('idle')

func _physics_process(delta):
	match state:
		EnemyState.CHASE:
			var target = player.global_position
			var direction = (target - global_position).normalized() 
			var desired_velocity =  direction * SPEED
			var steering = (desired_velocity - velocity) * delta * 2.5
			velocity += steering
		EnemyState.WANDER:
			var displacement_vector = target_wander_position - global_position
			if displacement_vector.length() < 0.1:
				state = EnemyState.IDLE
				return
			
			var desired_velocity = displacement_vector.normalized() * SPEED
			var steering = (desired_velocity - velocity) * delta * 2.5
			velocity += steering
		EnemyState.DEAD, EnemyState.IDLE:
			velocity = Vector2.ZERO
		
	move_and_slide()

	
func _die():
	state = EnemyState.DEAD
	$CollisionShape2D.disabled = true
	$VisiblityRegion/CollisionShape2D.disabled = true
	$Stuned.stop()
	$Wander.stop()
	$Sprite2D.play('death')

func _on_visiblity_region_body_entered(body: Node2D) -> void:
	if body.name == 'Hero' and state != EnemyState.DEAD:
		state = EnemyState.CHASE

func _on_visiblity_region_body_exited(body: Node2D) -> void:
	if body.name == 'Hero' and state != EnemyState.DEAD:
		state = EnemyState.IDLE

func _on_stuned_timeout() -> void:
	$CollisionShape2D.disabled = false
	$Stuned.stop()

func _on_wander_timeout() -> void:
	match state:
		EnemyState.WANDER:
			state = EnemyState.IDLE
		EnemyState.IDLE:
			state = EnemyState.WANDER
			target_wander_position = \
				global_position + randi_range(0, 100) * Vector2.from_angle(randf_range(0, TAU))
			print('New Target Pos = ', target_wander_position)

	$Wander.start()
