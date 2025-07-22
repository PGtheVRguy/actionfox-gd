extends Node2D


@onready var Animator = $Animator

func _process(delta: float) -> void: #For figuring out if the level is playable or not visually
	if (Global.compList.has(get_meta("LevelPath"))):
		Animator.play("a_played") 
	else:
		Animator.play("a_unplayed")
