extends CharacterBody2D


const walkSpeed = 50
const viewRange = 256
const viewWidth = 16

var walking = false

@onready var targetStop = $"../Stoppoints/Stop1"
@onready var checker = $stopChecker
@onready var camera = $Camera




func _physics_process(delta: float) -> void:
	if not walking:
		if Input.is_action_just_pressed("left"):
			runTowardsStop(Vector2(-1, 0))
		if Input.is_action_just_pressed("right"):
			runTowardsStop(Vector2(1, 0))
		if Input.is_action_just_pressed("down"):
			runTowardsStop(Vector2(0, 1))
		if Input.is_action_just_pressed("up"):
			runTowardsStop(Vector2(0, -1))
		if Input.is_action_just_pressed("jump"):
			var lev = targetStop.get_meta("LevelPath")
			if lev != null:
				Global.level = lev
				get_tree().change_scene_to_file("res://game.tscn")
		
	if walking: 
		print("---")
		print(targetStop.get_meta("levelName"))
		print(checker.global_position.distance_to(targetStop.global_position))
		if checker.global_position.distance_to(targetStop.global_position) < 0.5:
			velocity = Vector2.ZERO
			walking = false
	camera.global_position.y = global_position.y + sin(Global.tick/60.0)*2.0
	camera.global_position.x = global_position.x
	move_and_slide()
		
func checkPointExist(dir):
	if dir == Vector2.ZERO:
		return false  # avoid divide by zero

	var normalized_dir = dir.normalized()
	var origin = position

	for node in get_tree().get_nodes_in_group("stoppoint"):
		if not node is Node2D:
			continue

		var rel = node.position - origin
		var dot = rel.dot(normalized_dir)
		
		# 1. Is it in the forward direction and within range?
		if dot < 0 or dot > viewRange:
			continue
		
		# 2. Is it close to the directional line? (strip width)
		var perp = rel - normalized_dir * dot
		if perp.length() <= viewWidth:
			if checker.global_position.distance_to(node.global_position) > 0.5:
				targetStop = node
				return true

	return false
func runTowardsStop(vec2):
	if checkPointExist(vec2):
		print("AAA")
		velocity.x = vec2.x * walkSpeed
		velocity.y = vec2.y * walkSpeed
		walking = true
