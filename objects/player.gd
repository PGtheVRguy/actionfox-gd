extends CharacterBody2D

const SPEED := 240.0 # 4.0 * 60
const JUMP_VELOCITY := -420.0 # -7.0 * 60
const GRAVITY := 21.0 # 0.35 * 60
const grapple_max_speed = 7*60
const grapple_min_speed = 1*60
const max_ammo = 8.0

var can_jump := 10
var jump_am := 1
var mid_air := 1

var hp = 3.0
var ammo = 8.0
var reloading = false
var reload_timer = 0.0

var respawnPos = global_position


#Grapple values

var grap_position = Vector2.ZERO
var grap_time = 0
#Gun Values

var gun_timer = 0
var gun_timer_max = 3*60

#Win Values
var winPosition = Vector2.ZERO
var winOffset = 0.0


#GM values that I then convert cuz im epic
var hsp = 0 
var vsp = 0


var keys = 0


@onready
var camera = $"../Camera"
@onready
var body_sprite = $BodySprite

@onready
var arm_sprite = $ArmSprite
@onready
var tail_sprite = $TailSprite

@onready
var death_sprite = $DeathSprite



@onready
var animator = $"Animator"
@onready
var arm_animator = $ArmAnimator
@onready
var layer_bullet = get_node("/root/game/level/bullets")
@onready
var respawnArea = $respawnCols

enum states{GENERIC, DYING, WIN, GRAPPLE}

var state := states.GENERIC


var bullet = preload("res://objects/o_bullet.tscn")

func _ready() -> void:
	print("I am at: ", get_path())
	#bulletCollision.connect("area_entered", shot_check)


func _physics_process(_delta: float) -> void:
	match state:
		states.GENERIC:
			grap_time = 0
			if not is_on_floor():
				mid_air = 2
				if(velocity.y > 0):
					animator.current_animation = "p_jump_down"
					set_arm("p_jump_down", false)
			else:
				mid_air = 1

			var dir := Input.get_axis("left", "right")
			if dir != 0:
				var target_speed := dir * SPEED 
				velocity.x = lerp(velocity.x, target_speed, 0.05 / float(mid_air))
				
				if is_on_floor():
					
					
					var leftkey := Input.is_action_pressed("left")
					var rightkey := Input.is_action_pressed("right")
					
					if leftkey and rightkey:
						animator.current_animation = "p_idle"
						set_arm("p_idle", false)
						
					elif (leftkey and velocity.x > 0) or (rightkey and velocity.x < 0):
						if animator.current_animation != "p_skid":
							animator.stop()
							animator.play("p_skid")
							set_arm("p_skid", true)
					else:

						body_sprite.flip_h = dir < 0

						
						spriteDirectionOffset()
						
						animator.current_animation = "p_walk"
						set_arm("p_walk", false)
			else:
				
				velocity.x = move_toward(velocity.x, 0, SPEED * 0.1)
				if is_on_floor():
					animator.current_animation = "p_idle"
					set_arm("p_idle", false)

			velocity.y += GRAVITY

			if can_jump > 0 and Input.is_action_just_pressed("jump"):
				velocity.y = JUMP_VELOCITY
				animator.current_animation = "p_jump_up"
				set_arm("p_jump_up", false)
				jump_am -= 1
				can_jump = 0

			if is_on_floor() and velocity.y >= 0:
				can_jump = 10
				
			if Input.is_action_just_pressed("shoot"):
				if(ammo > 0 and reloading == false):
					print("SHOT")
					var scene_instance = bullet.instantiate()
					layer_bullet = get_bullet_layer()
					layer_bullet.add_child(scene_instance)
					scene_instance.global_position = arm_sprite.global_position
					scene_instance.rotation = arm_sprite.global_position.angle_to_point(get_global_mouse_position())
					scene_instance.global_position.y = scene_instance.global_position.y-2 #asd
					gun_timer = gun_timer_max
					arm_sprite.frame = 7 
					arm_animator.stop()
					arm_animator.play("p_gun_shoot")
					ammo -= 1
					if(ammo == 0):
						reloading = true
			if reloading == true:
				reload_timer += (1.0/30.0)
				print(reload_timer)
				if(reload_timer >= 1):
					reload_timer = 0
					ammo += 1
					ammo = clamp(ammo, 0, max_ammo)
					if(ammo == max_ammo):
						reloading = false
			if Input.is_action_just_pressed("reload"):
				reloading = true
			if gun_timer > 0:
				gun_timer -= 1

				# Switch to p_gun_out at frame 6 of p_gun_shoot
				if arm_animator.current_animation == "p_gun_shoot" and arm_sprite.frame == 6:
					arm_animator.play("p_gun_out")

				body_sprite.flip_h = global_position.x > get_global_mouse_position().x
				arm_sprite.rotation = arm_sprite.global_position.angle_to_point(get_global_mouse_position())
				spriteDirectionOffset()

				if body_sprite.flip_h:
					arm_sprite.rotation += deg_to_rad(180)
			else:
				arm_sprite.rotation = 0
				
			
		states.GRAPPLE:
			
			var _vx = clamp((grap_position.x - position.x)*60, -grapple_max_speed, grapple_max_speed)
			var _vy = clamp((grap_position.y - position.y)*60, -grapple_max_speed, grapple_max_speed)
			velocity.x = _vx
			velocity.y = _vy
			grap_time += 1
			if(position.distance_to(grap_position) < 32):
				state = states.GENERIC
			if(grap_time > 10):
				if Input.is_action_just_pressed("grapple"):
					state = states.GENERIC
		states.WIN:
			hsp = 0
			vsp = 0
			velocity.x = 0
			velocity.y = 0
			winOffset += 1.0/60.0
			print(winOffset)
			global_position.x = lerp(global_position.x, winPosition.x, 0.05)
			global_position.y = lerp(global_position.y, winPosition.y, 0.05)-winOffset
			if(winOffset > 4.0 ):
				Global.winLevel()
				#Global.transitionTo_Map()
		states.DYING:
			arm_sprite.visible = false
			body_sprite.visible = false 
			tail_sprite.visible = false
			death_sprite.visible = true
			animator.play("p_die")
			if(Input.is_action_just_pressed("jump")):
				Global.resetLevel()
	
	#check respawn area
	

	
	if(isRespawnAllowed()):
		respawnPos = global_position
	if(hp <= 0):
		state = states.DYING
	move_and_slide()
	
	hsp = velocity.x/60
	vsp = velocity.y/60
	
	#camera
	camera.global_position.x = lerp(camera.global_position.x, global_position.x+(hsp*28), 0.05)
	camera.global_position.y = lerp(camera.global_position.y, (global_position.y-48)+vsp*9, 0.05)
	
	

func _draw():
	match state:
		states.GRAPPLE:
			draw_line(global_position, grap_position, Color.BLUE, 4)

func grapple(position):
	grap_position = position
	state = states.GRAPPLE
	return true


func set_arm(name, forcestop):
	if(gun_timer <= 0):
		if(forcestop):
			if(arm_animator.current_animation != name):
				arm_animator.stop()
				arm_animator.play(name)
		else:
			arm_animator.current_animation = name
func spriteDirectionOffset():
	#arm_sprite.flip_h = body_sprite.flip_h
	if(body_sprite.flip_h):
		arm_sprite.scale.x = -1
	else:
		arm_sprite.scale.x = 1
	tail_sprite.flip_h = body_sprite.flip_h
	if(body_sprite.flip_h):
		#arm_sprite.global_position.x = global_position.x-16
		tail_sprite.global_position.x = global_position.x+8
		tail_sprite.global_position.y = global_position.y+1
	else:
		#arm_sprite.global_position.x = global_position.x
		tail_sprite.global_position.x = global_position.x-8
		tail_sprite.global_position.y = global_position.y+1
						
func damage(amount):
	hp -= amount
	


func get_bullet_layer():
	return get_node_or_null("/root/game/level/bullets")

func reset():
	print("Resetting player...")
	
	
	var layer_bullet = get_node_or_null("/root/game/level/bullets")
	print(layer_bullet)
	if layer_bullet == null:
		
		push_error("layer_bullet is null! Level probably hasn't loaded yet.")
		return

func win():
	state = states.WIN

func addKey():
	keys += 1
	return 0

func resetCamera():
	camera.global_position = global_position
func isRespawnAllowed(): #I'll be entirely honest I stole this part
	var left_hit = $ResLeft.get_overlapping_bodies().any(func(b): return b.is_in_group("floor"))
	var right_hit = $ResRight.get_overlapping_bodies().any(func(b): return b.is_in_group("floor"))
	return left_hit and right_hit
	
func softRespawn():
	global_position = respawnPos
	resetCamera()
	damage(1)
