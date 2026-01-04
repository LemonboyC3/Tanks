extends "res://tanks/Tank.gd"

@onready var parent = get_parent()
@export var turret_speed: float
@export var detect_radius: int

var target = null
var chase_target = null
var speed = 0.0

func _ready():
	$Smoke.emitting = false
	health = max_health
	$Cooldown.wait_time = gun_cooldown
	var circle = CircleShape2D.new()
	var chase_circle = CircleShape2D.new()
	$Body/DetectRadius/CollisionShape2D.shape = circle
	$Body/DetectRadius/CollisionShape2D.shape.radius = detect_radius
	$Body/ChaseRadius/CollisionShape2D.shape = chase_circle
	$Body/ChaseRadius/CollisionShape2D.shape.radius = detect_radius * 1.6

func control(delta):
	if chase_target:
		if $Body/LookAhead.is_colliding() or $Body/LookAhead2.is_colliding():
			speed = lerpf(speed, 0.0, 0.1)
		else:
			speed = lerpf(speed, max_speed, 0.1)
		velocity = Vector2()
		velocity = Vector2(speed, 0).rotated($Body.global_rotation)
		var target_dir = (chase_target.global_position-global_position).normalized()
		var current_dir = Vector2(1,0).rotated($Body.global_rotation)
		$Body.global_rotation = current_dir.lerp(target_dir,rotation_speed * delta).angle()
	else: 
		speed = lerpf(speed, 0.0, 0.1)
		velocity = Vector2()
		velocity = Vector2(speed, 0).rotated($Body.global_rotation)
	
func _process(delta):
	if target and alive:
		var target_dir = (target.global_position-global_position).normalized()
		var current_dir = Vector2(1,0).rotated($Turret.global_rotation)
		$Turret.global_rotation = current_dir.lerp(target_dir,turret_speed * delta).angle()
		if target_dir.dot(current_dir) > 0.9:
			shoot(gun_shots, gun_spread,target)
	else:
		var target_dir = (Vector2(1,0)).normalized().rotated($Body.global_rotation)
		var current_dir = Vector2(1,0).rotated($Turret.global_rotation)
		$Turret.global_rotation = current_dir.lerp(target_dir,turret_speed * delta).angle()
	


func _on_detect_radius_body_entered(body: Node2D) -> void:
	if body.name == "PlayerTank":
		target = body


func _on_detect_radius_body_exited(body: Node2D) -> void:
	if body == target:
		target = null
		
func _on_explosion_animation_finished():
	emit_signal("dead")
	var respawn_location = get_point_inside(Vector2(100,100),Vector2(6000,5500))
	set_position(respawn_location)
	health = max_health
	emit_signal('health_changed', health * 100/max_health)
	$Explosion.hide()
	$SpawnSmoke.show()
	$SpawnSmoke.play()
	


func _on_chase_radius_body_entered(body: Node2D) -> void:
	if body.name == "PlayerTank":
		chase_target = body


func _on_chase_radius_body_exited(body: Node2D) -> void:
	if body == chase_target:
		chase_target = null
		
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
