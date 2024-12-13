extends CharacterBody2D

@export var SPEED: float = 300.0
var flip = false

func _entered_exit(body: Node2D):
	if body.name != 'Hero':
		return
	get_tree().quit()

func _physics_process(delta: float) -> void:
	
	velocity = Vector2(0, 0)
	
	if Input.is_action_pressed('ui_left'):
		velocity.x = -SPEED
	if Input.is_action_pressed('ui_right'):
		velocity.x = SPEED
	if Input.is_action_pressed('ui_up'):
		velocity.y = -SPEED
	if Input.is_action_pressed('ui_down'):
		velocity.y = SPEED
		
	move_and_slide()

func _process(delta):
	var animation = 'idle'
	if velocity.length() > 0:
		animation = 'run'
	
	if Input.is_action_pressed('ui_left'):
		flip = true
	if Input.is_action_pressed('ui_right'):
		flip = false
	
	$HeroSprite.flip_h = flip
	$HeroSprite.play(animation)
