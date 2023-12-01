extends Node

var kills = 0

signal signal_update_kills
signal signal_give_seed
signal signal_player_gets_hit(damage,knockback_strength, enemy_position)

#----------------------------------------------------
func add_kill():
	kills += 1
	if kills == 5:
		signal_give_seed.emit()
		kills = 0

 
