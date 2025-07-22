extends StaticBody2D

@onready var col = $Area
@onready var player = get_node_or_null("/root/game/Player/body")

func _ready():
	col.connect("body_entered", respawnPlayer)
	
	
	


func respawnPlayer(col2):
	if col2 == player: 
		print("RESPAWNING PLAYER")
		player.softRespawn()
