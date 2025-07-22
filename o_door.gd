extends CharacterBody2D

@onready var collider = $Area
@onready var player = get_node_or_null("/root/game/Player/body")

func _ready():
	collider.connect("body_entered", keyCheck)




func keyCheck(collider2):
	if collider2 == player:
		if(player.keys > 0):
			player.keys -= 1
			open() 
		


func open():
	for i in range(48):
		global_position.y -= 1
