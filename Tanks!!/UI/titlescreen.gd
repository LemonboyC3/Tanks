extends Control
var canpress = false
func _ready():
	Input.set_custom_mouse_cursor(load("res://assets/UIImage/crossair_black.png"),Input.CURSOR_ARROW,Vector2(16,16))
	$AudioStreamPlayer.play()
	
	
func _input(event):
	if event.is_action_pressed("ui_select") and canpress == true:
		$AudioStreamPlayer2.play()
		$AnimationPlayer.play("select")
		canpress = false
		await get_tree().create_timer(0.5).timeout
		Globals.next_level()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "titleanimation":
		canpress = true
