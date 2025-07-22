extends StaticBody2D

@onready var winCol = $Zone
@onready var player = get_node_or_null("/root/game/Player/body")


func _ready():
	winCol.connect("body_entered", setWin)
	
	





func setWin(collider):
	if Global.tick > 10:
		print("WIN TIME BABY")
		if collider == player:
			player.winPosition = global_position
			player.win()
			
			#queue_free()
