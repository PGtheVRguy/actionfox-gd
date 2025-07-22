extends Sprite2D

func _ready() -> void:
	var player = get_node_or_null("/root/game/Player/body")
	player.global_position = global_position
	#player.get_node("../Camera").global_position = global_position
	player.resetCamera()
	queue_free()
