extends CharacterBody2D




var seePlayer = false
var viewedPosition = Vector2.ZERO

var moveSpeed := 6.0*60

var forgetTimer = 0
var stunTimer = 0

const GRAVITY := 21.0
const zombieViewDistance = 256.0
const forgetMaxTimer = 3
const stunMaxTimer = 10
@onready var playerView = $playerView
@onready var player = $/root/game/Player/body




func _physics_process(delta: float) -> void:
	if seePlayer:
		if(viewedPosition.x > global_position.x):
			velocity.x = lerp(velocity.x, moveSpeed, 0.05)
		else:
			velocity.x = lerp(velocity.x, -moveSpeed, 0.05)
		forgetTimer -= 1/60
		if(forgetTimer < 0):
			seePlayer = false
	
	
	velocity.y += GRAVITY
	stunTimer -= 1
	
	#print(player.global_position)
	if(player.global_position.distance_to(global_position) < zombieViewDistance):
		wakeUp()
	
	
	if(stunTimer < 0):
		move_and_slide()


func wakeUp():
	seePlayer = true
	forgetTimer = forgetMaxTimer
	viewedPosition = player.global_position


func player_in_view(collider):
	if collider == get_node("/root/game/Player/body"):
		viewedPosition = get_node("/root/game/Player/body").global_position
		seePlayer = true
		forgetTimer = forgetMaxTimer
