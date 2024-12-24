extends CharacterBody2D

signal player_hit(player: CharacterBody2D, points: float)

func _physics_process(delta: float) -> void:
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider.name == 'Hero':
			emit_signal('player_hit', collider as CharacterBody2D, 12)
			$CollisionPolygon2D.disabled = true
			$Timeout.start()
	
	velocity = Vector2.ZERO
	move_and_slide()

func _on_timeout_timeout() -> void:
	$CollisionPolygon2D.disabled = false
	
