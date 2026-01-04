extends Node
var paused = false
var terrain = [0,10,20,30,7,8,17,18]
var current_level = 0 # Never gonna happen
var score = 0 # Do dat later
var levels = ["res://UI/titlescreen.tscn","res://maps/map_01.tscn"]
func restart():
	current_level = 0
	Transition.transition()
	await Transition.transitionfinished
	get_tree().change_scene_to_file(levels[current_level])

func next_level():
	current_level += 1
	if current_level < levels.size():
		Transition.transition()
		await Transition.transitionfinished
		get_tree().change_scene_to_file(levels[current_level])
	else:
		restart()
		# Add win or credits. Never gonna happen
	
