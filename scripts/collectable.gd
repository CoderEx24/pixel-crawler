extends Node2D

signal collected(collectable: String)

var collectable = ['wooden_sword', 'wooden_axe'].pick_random()

func _ready() -> void:
	$Range/CollisionShape2D.disabled = true
	$Sprite2D.texture = load('res://resources/%s.tres' % collectable)


func _process(delta: float) -> void:
	pass


func _on_disabled_timeout() -> void:
	$Range/CollisionShape2D.disabled = false

func _on_range_body_entered(body: Node2D) -> void:
	if body.name == 'Hero':
		emit_signal('collected', collectable)
	queue_free()
