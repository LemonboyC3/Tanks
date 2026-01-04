extends CanvasLayer

signal transitionfinished
@onready var colorrect = $ColorRect
@onready var animationplayer = $AnimationPlayer

func _ready():
	colorrect.visible = false
	
func transition():
	colorrect.visible = true
	animationplayer.play("fadein")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "fadein":
		transitionfinished.emit()
		animationplayer.play("fadeout")
	elif anim_name == "fadeout":
		colorrect.visible = false
