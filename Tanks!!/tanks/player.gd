extends "res://tanks/Tank.gd"
var idle
func control(delta):
	idle = true
	if Globals.paused == false:
		$Turret.look_at(get_global_mouse_position())
	var rotdir = 0
	if Input.is_action_pressed("turnleft"):
		idle = false
		rotdir -= 1
	if Input.is_action_pressed("turnright"):
		idle = false
		rotdir += 1
	rotation += rotation_speed * rotdir * delta
	
	velocity = Vector2()
	if Input.is_action_pressed("forward"):
		idle = false
		velocity = Vector2(max_speed, 0).rotated(rotation)
	if Input.is_action_pressed("back"):
		idle = false
		velocity = Vector2(-max_speed/1.5, 0).rotated(rotation)
	if Input.is_action_pressed("click"):
		if Globals.paused == false:
			shoot(gun_shots,gun_spread)
	if Globals.paused == false and dead:
		if idle == true:
			$Enginerunning.stop()
			if not $Engineidle.playing:
				$Engineidle.play()
		else:
			$Engineidle.stop()
			if not $Enginerunning.playing:
				$Enginerunning.play()
	else:
		$Engineidle.stop()
		$Enginerunning.stop()
		
	position.x = clamp(position.x, $Camera2D.limit_left, $Camera2D.limit_right)
	position.y = clamp(position.y, $Camera2D.limit_top, $Camera2D.limit_bottom)
