extends Node2D


@onready var Animator = $Animator

func _process(delta: float) -> void:
	if (Global.compList.has(get_meta("LevelPath"))):
		Animator.play("a_played")
	else:
		Animator.play("a_unplayed")
