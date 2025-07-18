extends CharacterBody2D

@export var speed = 6*60

@onready var collider = $collider

func _ready():
	collider.connect("body_entered", collide)


func _physics_process(delta: float) -> void:
	velocity = Vector2(1, 0).rotated(rotation) * speed
	move_and_slide()
	
func collide(collider2):
	#print(collider2)
	if collider2 == get_node("/root/game/level/TileMapLayer"):
		queue_free()
