extends CharacterBody2D

class_name Enemy

enum EnemyState {
	CHASE,
	IDLE,
	DEAD,
}

@onready var player = get_parent().get_node('Hero')
var SPEED = 30
@export var health_points = 100
var randomnum
var state = EnemyState.CHASE

func _ready():
	$Sprite2D.animation = 'idle'
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	randomnum = rng.randf()
	
func _process(_delta: float) -> void:
	$HealthPoints.value = health_points
	
	match state:
		EnemyState.DEAD:
			$Sprite2D.animation = 'death'
			$VisiblityRegion/CollisionShape2D.disabled = true
			$CollisionShape2D.disabled = true
		_:
			pass

func _physics_process(delta):
	match state:
		EnemyState.CHASE:
			var target = get_circle_position(randomnum)
			var direction = (target - global_position).normalized() 
			var desired_velocity =  direction * SPEED
			var steering = (desired_velocity - velocity) * delta * 2.5
			velocity += steering
		EnemyState.IDLE:
			velocity = Vector2.ZERO
		EnemyState.DEAD:
			velocity = Vector2.ZERO
		
	move_and_slide()

func get_circle_position(random):
	var kill_circle_centre = player.global_position
	var radius = 40
	var angle = random * PI * 2;
	var x = kill_circle_centre.x + cos(angle) * radius;
	var y = kill_circle_centre.y + sin(angle) * radius;

	return Vector2(x, y)

func deal_damage(damage: int):
	health_points = max(0, health_points - damage)
	if health_points == 0:
		state = EnemyState.DEAD

func _on_visiblity_region_body_entered(body: Node2D) -> void:
	if body.name == 'Hero':
		state = EnemyState.CHASE

func _on_visiblity_region_body_exited(body: Node2D) -> void:
	if body.name == 'Hero':
		state = EnemyState.IDLE
