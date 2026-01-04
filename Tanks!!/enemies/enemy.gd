extends "res://tanks/Tank.gd"

@onready var parent = get_parent()
@export var turret_speed: float
@export var detect_radius: int
var target = null
var speed = 0.0

func _ready():
	$Smoke.emitting = false
	randomize()
	health = max_health
	$Cooldown.wait_time = gun_cooldown
	var circle = CircleShape2D.new()
	$DetectRadius/CollisionShape2D.shape = circle
	$DetectRadius/CollisionShape2D.shape.radius = detect_radius
	

func control(delta):
	if parent is PathFollow2D:
		# DEFENITELY a Tracker (On track so well...)
		if $LookAhead.is_colliding() or $LookAhead2.is_colliding():
			speed = lerpf(speed, 0.0, 0.1)
		else:
			speed = lerpf(speed, max_speed, 0.1)
		parent.set_progress(parent.get_progress() + speed * delta)
		position = Vector2()
	else:
		if max_speed == 0:
			# That's probably a Turret
			velocity = Vector2()
		else:
			pass
		
	
func _process(delta):
	if target and alive:
		var target_dir = (target.global_position-global_position).normalized()
		var current_dir = Vector2(1,0).rotated($Turret.global_rotation)
		$Turret.global_rotation = current_dir.lerp(target_dir,turret_speed * delta).angle()
		if target_dir.dot(current_dir) > 0.9:
			shoot(gun_shots, gun_spread,target)
	elif parent is PathFollow2D  :
		var target_dir = (Vector2(1,0)).normalized().rotated($Body.global_rotation)
		var current_dir = Vector2(1,0).rotated($Turret.global_rotation)
		$Turret.global_rotation = current_dir.lerp(target_dir,turret_speed * delta).angle()
	

	


func _on_detect_radius_body_entered(body: Node2D) -> void:
		target = body


func _on_detect_radius_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
		
func _on_explosion_animation_finished():
	emit_signal("dead")
	if parent is PathFollow2D:
		parent.set_progress(0)
		$Body.show()
		$Turret.show()
		$Explosion.hide()
		health = max_health
		emit_signal('health_changed', health * 100/max_health)
		alive = true
		
		
	else:
		var respawn_location = get_point_inside(Vector2(100,100),Vector2(6000,5500))
		set_position(respawn_location)
		health = max_health
		emit_signal('health_changed', health * 100/max_health)
		$Explosion.hide()
		$SpawnSmoke.show()
		$SpawnSmoke.play()
	
		
func get_point_inside(p1: Vector2, p2: Vector2) -> Vector2:
	var x: float = randf_range(p1.x,p2.x)
	var y: float = randf_range(p1.y,p2.y)
	var random_point = Vector2(x,y)
	return(random_point)
	


func _on_spawn_smoke_animation_finished() -> void:
	$Turret.show()
	$Body.show()
	$SpawnSmoke.hide()
	alive = true
	
