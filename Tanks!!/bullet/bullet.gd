extends Area2D

@export var speed: int
@export var damage: int
@export var lifetime: float
@export var steer_force: float = 0

var velocity = Vector2()
var acceleration = Vector2()
var target = null

func start(_position, _direction, _target=null):
	position = _position
	rotation = _direction.angle()
	$Lifetime.wait_time = lifetime
	$Lifetime.start()
	velocity = _direction * speed
	target = _target
	
func _process(delta):
	if target:
		acceleration += seek()
		velocity += acceleration * delta
		velocity = velocity.limit_length(speed)
		rotation = velocity.angle()
	position += velocity * delta

func seek():
	var desired = (target.position - position).normalized() * speed
	var steer = (desired - velocity).normalized() * steer_force
	return steer

func explode():
	velocity = Vector2()
	$Sprite2D.hide()
	$Explosion.show()
	$Explosion.play("smoke")
	$ShellExplode.play()

func _on_body_entered(body):
	explode()
	if body.has_method('take_damage'):
		body.take_damage(damage)
	


func _on_lifetime_timeout():
	explode()


func _on_explosion_animation_finished():
	queue_free()
