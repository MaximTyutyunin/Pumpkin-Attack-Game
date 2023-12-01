extends CharacterBody2D

@export var speed = 670
@export var friction = 20
@export var acceleration = 10
@export var area_2d_bullet : PackedScene
@export var score = 0
@export var seeds = 0


var input_direction

func _ready():
	EventBus.connect("signal_update_score", update_score)
	EventBus.connect("signal_2give_seed", update_seeds)


func _physics_process(delta):
	$Marker2D_Muzzle/Sprite2D_fire.visible = false
	# Calculate input strengths once
	var right_input = Input.get_action_strength("right")
	var left_input = Input.get_action_strength("left")
	var backward_input = Input.get_action_strength("backward")
	var forward_input = Input.get_action_strength("forward")

	input_direction = Vector2(right_input - left_input, backward_input - forward_input)
	
	if Input.is_action_just_pressed("shoot"):
		shoot()
		
	if input_direction.length() > 0:
		velocity = lerp(velocity, input_direction.normalized() * speed, acceleration * delta )
	else:
		velocity = lerp(velocity, Vector2.ZERO, friction * delta)
	
	move_and_slide()

func shoot():
	var b = area_2d_bullet.instantiate()
	owner.add_child(b)
	b.transform = $Marker2D_Muzzle.global_transform
	$Marker2D_Muzzle/Sprite2D_fire.visible = true
	
func update_score():
	score += 1
	print("score ", score)

func update_seeds():
	seeds += 1
	print("Seed should be given now: ", seeds)
