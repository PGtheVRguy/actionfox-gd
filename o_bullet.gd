extends CharacterBody2D

@export var speed = 6*60


func _physics_process(delta: float) -> void:
	velocity = Vector2(1, 0).rotated(rotation) * speed
	move_and_slide()
	
