extends Node

var level = null
var tick = 0
var compList = []
var inMenu = true
var mapPos = Vector2.ZERO

func _process(delta: float) -> void:
	if(!inMenu):
		tick += 1
	
	
func reset():
	tick = 0

func transition():
	return 0
	

func winLevel():
	compList.append(level)
	transitionTo_Map()


func transitionTo_Map():
	transition()
	get_tree().change_scene_to_file("res://worldmap.tscn")


func resetLevel():
	reset()
	get_tree().reload_current_scene()
