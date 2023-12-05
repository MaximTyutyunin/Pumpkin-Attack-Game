extends Area2D

var speed = 750.0
var max_travel_distance = 1000
var traveled_distance = 0

#----------------------------------------------------

func _physics_process(delta):
	var distance = speed * delta
	traveled_distance += distance
	position += transform.x * speed * delta
	
	if max_travel_distance < distance:
		queue_free()

func _on_area_entered(area):
	if area.is_in_group("damage_zone_area") && area.is_in_group("weapon") == false:
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("obstacle"):
		queue_free()
