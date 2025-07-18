extends CharacterBody2D




var seePlayer = false
var viewedPosition = Vector2.ZERO

var moveSpeed := 5.0*60

var forgetTimer = 0
var stunTimer = 0
var attackTimer = 0
var hp = 3


const GRAVITY := 21.0
const zombieViewDistance = 256.0
const attackDistance = 16.0
const forgetMaxTimer = 3
const stunMaxTimer = 10
const attackMaxTimer = 10
const damage = 0.5

@onready var playerView = $playerView
@onready var player = $/root/game/Player/body
@onready var bulletCollision = $bulletCheck

@onready var leftFloorCheck = $floorChecks/left
@onready var rightFloorCheck = $floorChecks/right


func _ready():
	bulletCollision.connect("area_entered", shot_check)



func _physics_process(delta: float) -> void:
	if seePlayer:
		if(viewedPosition.x > global_position.x):
			velocity.x = lerp(velocity.x, moveSpeed, 0.05)
		else:
			velocity.x = lerp(velocity.x, -moveSpeed, 0.05)
		forgetTimer -= 1/60
		if(forgetTimer < 0):
			seePlayer = false
	if(player.global_position.distance_to(global_position) < attackDistance):
		attackTimer += 1
	else:
		attackTimer -= 1
	attackTimer = clamp(attackTimer, 0, 99)
	if(attackTimer > attackMaxTimer):
		player.damage(damage)
		attackTimer = 0.0
	
	velocity.y += GRAVITY
	stunTimer -= 1
	
	#print(player.global_position)
	if(player.global_position.distance_to(global_position) < zombieViewDistance):
		wake_up()
	
	
	if(stunTimer < 0):
		move_and_slide()
	else:
		velocity.x = 0
	if(hp <= 0 ):
		queue_free()


func wake_up():
	seePlayer = true
	forgetTimer = forgetMaxTimer
	viewedPosition = player.global_position


func player_in_view(collider):
	if collider == get_node("/root/game/Player/body"):
		viewedPosition = get_node("/root/game/Player/body").global_position
		seePlayer = true
		forgetTimer = forgetMaxTimer
func shot_check(collider):
	print(collider)
	print("OUCH")
	if collider.is_in_group("bullet"):
		collider.get_parent().queue_free()
		hp -= 1
		stunTimer = stunMaxTimer
