extends Node

var level = null
var tick = 0
var compList = []



func _process(delta: float) -> void:
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
