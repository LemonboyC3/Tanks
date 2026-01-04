extends CharacterBody2D

signal health_changed
signal dead
signal fire
# fire, not shoot to prevent clash
@export var Bullet: PackedScene
@export var max_speed: int
@export var rotation_speed: float
@export var gun_cooldown: float
@export var max_health: int
@export var gun_shots: int = 1
@export var gun_spread: float = 0.2
@export var offroad_friction = 2
# Rename velocity or whatnot to Velocity to avoid clash
# velocity = Vector2()
var can_shoot = true
var alive = true
var health
var map

func _ready():
	$Smoke.emitting = false
	$Cooldown.wait_time = gun_cooldown
	health = max_health
	emit_signal("health_changed", health * 100/max_health)


func control(_delta): 
	pass

func shoot(num, spread, target = null):
	if can_shoot:
		can_shoot = false
		$Cooldown.start()
		var dir = Vector2(1,0).rotated($Turret.global_rotation)
		if num > 1:
			for i in range(num):
				var a = -spread + i * (2*spread)/(num-1)
				emit_signal('fire',Bullet, $Turret/Muzzle.global_position, dir.rotated(a), target)
		else:
			emit_signal('fire',Bullet, $Turret/Muzzle.global_position, dir, target)
		$AnimationPlayer.play("muzzle_flash")
		if has_node("ShootSFX"):
			$ShootSFX.play()

func _physics_process(delta):
	if not alive:
		return
	control(delta)
	#if map:
		#var tile = map.get_cell_source_id(map.local_to_map(position))
		#if not tile in Globals.terrain:
			#velocity *= offroad_friction
	move_and_slide() # small velocity plugged in already

func take_damage(amount):
	if alive == true:
		health -= amount
		emit_signal('health_changed', health * 100/max_health)
		if health < roundf(max_health / 2.0):
			$Smoke.emitting = true
		if health <= 0:
			explode()
		if has_node("ShootSFX"):
			if gun_shots != 0:
				gun_shots -= 1

func heal(amount):
	$ItemGet.play()
	health += amount
	if health > max_health:
		health = max_health
	if health >= roundf(max_health / 3.0):
		$Smoke.emitting = false
	emit_signal('health_changed', health * 100/max_health)
	
func spreadshot(amount):
	$ItemGet.play()
	gun_shots = amount
func explode():
	$Smoke.emitting = false
	alive = false
	#Deal with DAT later
	#$CollisionShape2D.disabled = true
	$Turret.hide()
	$Body.hide()
	$Explosion.show()
	$Explosion.play()
	$Explode.play()
	
func _on_cooldown_timeout():
	can_shoot = true


func _on_explosion_animation_finished():
	if has_node("ShootSFX"):
		$Explosion.hide()
	else:
		queue_free()
	emit_signal("dead")
	
