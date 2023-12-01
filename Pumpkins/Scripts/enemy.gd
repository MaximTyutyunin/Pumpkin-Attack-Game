extends CharacterBody2D

signal enemy_attack(damage,knockback_strength, enemy_position)

@export var speed = 250

@onready var attack_delay_timer: Timer = $AttackDelayTimer

var hp = 5
var player_detected = false
var mov_direction = Vector2()
var player_ref: CharacterBody2D

#----------------------------------------------------

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	for player in players:
		pass

func _physics_process(delta: float) -> void:
	if player_ref and hp > 0:
		accelerate_towards_point(player_ref.global_position, delta)
		move_and_slide()
		#does the same, just old version of it
	#var players = get_tree().get_nodes_in_group("player")
	#if players.size() > 0 && player_detected == true:
#		var player = players[0]
#		accelerate_towards_point(player, delta)
#		move_and_slide()

func _on_damage_zone_area_entered(area: Area2D) -> void:
	if area.is_in_group("weapon"):
		hp -= 1
		if hp <= 0:
			EventBus.signal_update_kills.emit()
			EventBus.add_kill()
			queue_free()


func accelerate_towards_point(target_position: Vector2, delta: float) -> void:
	mov_direction = (target_position - global_position).normalized()
	velocity = velocity.move_toward(mov_direction * speed, 350 * delta)

func _on_seek_player_zone_body_entered(body: Node2D) -> void:
		if body.is_in_group("player"):
			player_ref = body

func _on_seek_player_zone_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_ref = null


func _on_hit_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# Start the timer instead of attacking immediately
		attack_delay_timer.start() 


func _on_attack_delay_timer_timeout() -> void:
	# This function is called when the timer times out
	if player_ref and player_ref.is_in_group("player"):
		EventBus.signal_player_gets_hit.emit(1, 1800, self.global_position)


func _on_hit_zone_body_exited(body: Node2D) -> void:
	#when player leavesthe danger zone the timer should be stopped 
	#to prevent damage out of nowhere
	if body.is_in_group("player"):
		attack_delay_timer.stop() 
