extends Node2D


var mouseIn = false

@onready
var mouseArea = $MouseArea

@onready
var player = get_node("/root/game/Player/body")

@onready
var grapplePoint = $GrapplePoint

@onready
var indicator = $GrapplePoint/Indicator



func _physics_process(delta: float) -> void:

	#print(get_global_mouse_position())
	indicator.visible = indicator.global_position.distance_to(get_global_mouse_position()) < 20
		#print('a')
	indicator.rotate(deg_to_rad(2))

	if Input.is_action_just_pressed("grapple") and indicator.visible:
		print("GRAPPLED")
		player.grapple(grapplePoint.global_position)
