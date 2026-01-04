extends Node2D

func _ready():
	set_camera_limits()
	$MainTheme.play()
	Input.set_custom_mouse_cursor(load("res://assets/UIImage/crossair_black.png"),Input.CURSOR_ARROW,Vector2(16,16))
	#$PlayerTank.map = $Ground
func set_camera_limits():
	var map_limits = $Ground.get_used_rect()
	
	# Use either set, as ground cell size sucks
	#var map_cellsize = $Ground.cell_size
	var map_cellsize = 128 
	
	# Use top code if ground cell size works
	#$PlayerTank/Camera2D.limit_left = map_limits.position.x * map_cellsize.x
	#$PlayerTank/Camera2D.limit_right = map_limits.end.x * map_cellsize.x
	#$PlayerTank/Camera2D.limit_top = map_limits.position.y * maddwdp_cellsize.y
	#$PlayerTank/Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y
	$PlayerTank/Camera2D.limit_left = map_limits.position.x * map_cellsize
	$PlayerTank/Camera2D.limit_right = map_limits.end.x * map_cellsize
	$PlayerTank/Camera2D.limit_top = map_limits.position.y * map_cellsize
	$PlayerTank/Camera2D.limit_bottom = map_limits.end.y * map_cellsize
	
func _process(_delta):
	if Input.is_action_just_pressed("Pause"):
		if Globals.paused == false:
			$Pause.show()
			$Pause/AudioStreamPlayer2.play()
			Globals.paused = true
			Engine.time_scale = 0
		else:
			$Pause.hide()
			$Pause/AudioStreamPlayer2.play()
			Globals.paused = false
			Engine.time_scale = 1

func _on_Tank_shoot(bullet, _position, _direction, _target = null):
	var b = bullet.instantiate()
	add_child(b)
	b.start(_position, _direction, _target)

func _on_player_tank_dead():
	await get_tree().create_timer(1.5).timeout
	Globals.score = 0
	Globals.restart()
	
func _on_tank_destroyed():
	$HUD._score_update(1)
