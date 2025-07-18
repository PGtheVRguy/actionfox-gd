extends Control


@onready
var player = get_node("/root/game/Player/body")

@onready
var ammoSprite = $CanvasLayer/MarginContainer/bottom_left/g_ammo
@onready
var hearts = "./CanvasLayer/MarginContainer/top_left"


func _process(delta: float) -> void:
	
	#AMMO
	var _w = 16*player.ammo
	ammoSprite.texture.region = Rect2(_w,0,16,64)

	#HEARTS (really bad)
	for n in 3:
		var heart = get_node(str(hearts, "/g_heart", n))
		if(player.hp > n): #idk how I got this working, but it did
			var offset = clamp(player.hp - n, 0, 1)
			heart.texture.region = Rect2((offset*2)*16,0,16,16)
		else:
			heart.texture.region = Rect2(0,0, 16, 16)
		
