extends CharacterBody2D

@export var speed = 2*60

@onready var collider = $collider

@onready var player = get_node_or_null("/root/game/Player/body")

func _ready():
	collider.connect("body_entered", collide)


func _physics_process(delta: float) -> void:
	velocity = Vector2(1, 0).rotated(rotation) * speed
	move_and_slide()
	
func collide(collider2):
	#print(collider2)
	if collider2 == get_node("/root/game/level/TileMapLayer"):
		queue_free()
	if collider2 == player:
		player.damage(0.5)
		queue_free()
	
