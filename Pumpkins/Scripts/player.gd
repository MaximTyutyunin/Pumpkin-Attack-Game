extends CharacterBody2D


@export var speed = 170
@export var friction = 20
@export var acceleration = 10
@export var bullet : PackedScene
@export var BULLET_MAX_AMOUNT = 15
@export var bullet_count = 0
@export var kills = 0
@export var fertilizer = 0
@export var hp = 5

@onready var mele_weapon: CollisionShape2D = $Marker2D_Muzzle/MeleWeapon/CollisionShape2D
@onready var weapon_timer: Timer = $WeaponTimer
@onready var recharge_weapon_timer: Timer = $Marker2D_Muzzle/MeleWeapon/RechargeWeaponTimer
@onready var UI: UI = $UI
@onready var reload_timer: Timer = $ReloadTimer
@onready var camera_2d: Camera2D = $Camera2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var anim_state = animation_tree.get("parameters/playback")
@onready var shovel_dmg_zone: CollisionShape2D = $Marker2D_Muzzle/MeleWeapon/CollisionShape2D
@onready var shovel_hit_animation: AnimationPlayer = $Marker2D_Muzzle/MeleWeapon/ShovelHitAnimation
@onready var shovel_sprite: Sprite2D = $Marker2D_Muzzle/MeleWeapon/ShovelSprite

@onready var audio_player_shoot: AudioStreamPlayer2D = $AudioPlayer_Shoot
@onready var audio_player_reaload: AudioStreamPlayer2D = $AudioPlayer_Reaload
@onready var audio_player_walking: AudioStreamPlayer2D = $AudioPlayer_Walking
@onready var audio_player_hit: AudioStreamPlayer2D = $AudioPlayer_Hit


var is_reloading: bool
var input_direction

enum player_staes {MOVE, DEATH, MELEE}
var currnt_state = player_staes.MOVE
#----------------------------------------------------

func _ready():
	shovel_dmg_zone.disabled = true
	shovel_sprite.hide()
	#this line should be called only after the animation tree is ready 
	#thats why its here and not outside the ready function 
	#or use @onready to get the same result
	#anim_state = animation_tree.get("parameters/playback")
	#update_camera_limits() #this is another way of setting the camera but i didnt use it
	is_reloading = false
	UI.update_health_ui(hp) #set initial lives when spawning
	UI.update_kills(kills)
	UI.update_fertilizer(fertilizer)
	weapon_timer.wait_time = 0.5
	bullet_count = BULLET_MAX_AMOUNT#set initial bullets
	UI.update_ammo(bullet_count)
	EventBus.connect("signal_update_kills", update_kills)
	EventBus.connect("signal_give_seed", update_seeds)
	EventBus.connect("signal_player_gets_hit", on_get_hit)


func _physics_process(delta):
	move(delta)

func move(delta: float):
	$Marker2D_Muzzle/Sprite2D_fire.visible = false
	# Calculate input strengths once
	var right_input = Input.get_action_strength("right")
	var left_input = Input.get_action_strength("left")
	var backward_input = Input.get_action_strength("backward")
	var forward_input = Input.get_action_strength("forward")

	input_direction = Vector2(right_input - left_input, backward_input - forward_input)
	var input_norm = input_direction.normalized()
	if Input.is_action_just_pressed("shoot"):
		is_reloading = false
		shoot()
		
	if Input.is_action_just_pressed("reload"):
		start_reload()
		
	if Input.is_action_just_pressed("mele_attack"):
		shovel_hit_animation.play("hit")
		
		
	#	mele_atk()
		
	if input_direction.length() > 0:
		velocity = lerp(velocity, input_norm * speed, acceleration * delta )
		animation_tree.set("parameters/Idle/blend_position", input_norm)
		animation_tree.set("parameters/Move/blend_position", input_norm)
		animation_tree.set("parameters/Melee/blend_position", input_norm)
		anim_state.travel("Move")
	else:
		anim_state.travel("Idle")
		velocity = lerp(velocity, Vector2.ZERO, friction * delta)
	
	move_and_slide()
	
func shoot():
	if bullet_count > 0:
		var b = bullet.instantiate()
		owner.add_child(b)
		b.transform = $Marker2D_Muzzle.global_transform
		$Marker2D_Muzzle/Sprite2D_fire.visible = true
		audio_player_shoot.play()
		bullet_count -= 1 #set initial bullets
		UI.update_ammo(bullet_count)

func update_kills():
	kills += 1
	UI.update_kills(kills)

func update_seeds():
	fertilizer += 1
	UI.update_fertilizer(fertilizer)

func update_hp():
	hp -= 1

func death():
	queue_free()

func update_camera_limits():
	var tilemap_rect = get_parent().get_node("TileMap").get_used_rect()
	#var tilemap_cell_size = get_parent().get_node("TileMap").cell_quadrant_size
	#i use 16 beacause all tiles are 16x16  pixels anyways and no need to recalculate them
	camera_2d.limit_left = tilemap_rect.position.x * 16#* tilemap_cell_size.x
	camera_2d.limit_right = tilemap_rect.end.x * 16 #* tilemap_cell_size.x
	camera_2d.limit_top = tilemap_rect.position.y * 16#* tilemap_cell_size.y
	camera_2d.limit_bottom = tilemap_rect.end.y * 16#* tilemap_cell_size.y

func on_get_hit(damage, knockback_strength, enemy_position):
	hp -= damage
	#call a function on the UI scene
	UI.update_health_ui(hp)
	var knockback_direction = global_position - enemy_position
	knockback_direction = knockback_direction.normalized()
	# Apply the knockback effect
	velocity += knockback_direction * knockback_strength
	if hp <= 0:
		death()

"func start_reload():
	if not is_reloading and bullet_count < BULLET_MAX_AMOUNT:
		is_reloading = true
		
		for i in BULLET_MAX_AMOUNT - bullet_count:
			bullet_count += 1  # Increase ammo count
			UI.update_ammo(bullet_count)  # Update UI
			await get_tree().create_timer(0.2).timeout
			
		is_reloading = false"
#func mele_atk():
#the fucntion is not in use but is useful for learning"
#	if recharge_weapon_timer.is_stopped():
#		#anim_state.travel("Melee") this line doesnt work , coz it gets overrriten 
		#by other animations in physics_process function
#		mele_weapon.disabled = false
#		# i added this line to make shure that the node 
#		# will have time to be detected by an enemy
#		await get_tree().create_timer(0.1).timeout
#		mele_weapon.disabled  = true
#		recharge_weapon_timer.start()

func start_reload():
	"""
	1. Configure your reload timer to tick at regular intervals. 
	   Each tick will represent one unit of ammo being reloaded.
	2. Update the Ammo Count on Each Tick in _on_reload_timer_timeout()
	3. Stop the Timer When Full
	"""
	if not is_reloading and bullet_count < BULLET_MAX_AMOUNT:
		is_reloading = true
		reload_timer.start()  # Start the timer


func _on_reload_timer_timeout():
	if bullet_count < BULLET_MAX_AMOUNT && is_reloading == true:
		bullet_count += 1
		audio_player_reaload.play()
		UI.update_ammo(bullet_count)
	if bullet_count < BULLET_MAX_AMOUNT && is_reloading == true:
		reload_timer.start()  # Start the timer again for the next bullet
	else:
		is_reloading = false
