extends CanvasLayer

var bar_red = preload("res://assets/UIImage/barHorizontal_red_mid 200.png")
var bar_green = preload("res://assets/UIImage/barHorizontal_green_mid 200.png")
var bar_yellow = preload("res://assets/UIImage/barHorizontal_yellow_mid 200.png")
var bar_texture


func update_healthbar(value):
	bar_texture = bar_green
	if value < 60:
		bar_texture = bar_yellow
	if value < 30:
		bar_texture = bar_red
	
	$MarginContainer/Container/HealthBar.texture_progress = bar_texture
	var tween = create_tween()
	tween.tween_property(
		$MarginContainer/Container/HealthBar,
		"value",
		value,
		0.3
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)	
	$AnimationPlayer.play("healthbar_flash")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "healthbar_flash":
		$MarginContainer/Container/HealthBar.texture_progress = bar_texture

func _score_update(amount):
	Globals.score += amount
	$MarginContainer/Container/Label.text = "DESTROYED: " + str(Globals.score)
