extends CharacterBody2D



var startPos = global_position
var offsetPos = 0.0


@onready var collider = $Area
@onready var player = get_node_or_null("/root/game/Player/body") #I hope this counts as a second of extra work
@onready var sound = $SndGrabkey


func _ready():
	collider.connect("body_entered", collided)



func _physics_process(delta: float) -> void:
	offsetPos =  sin(Global.tick/60.0)*0.2
	#print(offsetPos)
	global_position.y += offsetPos

func collided(collider2):
	if collider2 == player:
		player.addKey()
		#sound.play()
		queue_free()

func reset():
	offsetPos = global_position.y
