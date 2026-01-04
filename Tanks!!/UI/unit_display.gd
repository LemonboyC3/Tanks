extends Node2D

var bar_red = preload("res://assets/UIImage/barHorizontal_red_mid 200.png")
var bar_green = preload("res://assets/UIImage/barHorizontal_green_mid 200.png")
var bar_yellow = preload("res://assets/UIImage/barHorizontal_yellow_mid 200.png")

func _ready():
	for node in get_children():
		node.hide()

func _process(_delta):
	global_rotation = 0

func update_healthbar(value):
	$HealthBar.texture_progress = bar_green
	if value < 100:
		$HealthBar.show()
	if value < 60:
		$HealthBar.texture_progress = bar_yellow
	if value < 30:
		$HealthBar.texture_progress = bar_red
		
	var tween = create_tween()
	tween.tween_property(
		$HealthBar,
		"value",
		value,
		0.3
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)	
	#$HealthBar.value = value
