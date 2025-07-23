extends StaticBody2D

var timer = 0.0
@onready var player = get_node_or_null("/root/game/Player/body")
@onready var layer_bullet = get_node("/root/game/level/bullets")
var bullet = preload("res://objects/o_fireball.tscn")


func _process(delta: float) -> void:
	timer -= 1.0/60.0
	if(timer < 0):
		var scene_instance = bullet.instantiate()
		layer_bullet = player.get_bullet_layer()
		layer_bullet.add_child(scene_instance)
		scene_instance.global_position = global_position
		scene_instance.global_rotation = global_rotation
		timer = 3.0
