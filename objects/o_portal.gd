extends StaticBody2D

@onready var winCol = $Zone
@onready var player = get_node_or_null("/root/game/Player/body")
@onready var sound = $Sound

func _ready():
	winCol.connect("body_entered", setWin)
	
	





func setWin(collider):
	if Global.tick > 10:
		print("WIN TIME BABY")
		if collider == player:
			player.winPosition = global_position
			sound.play()
			player.win()
			
			#queue_free()
