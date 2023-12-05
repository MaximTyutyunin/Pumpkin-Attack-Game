extends Area2D

var can_interact = false

@onready var hint: Sprite2D = $Hint

signal signal_interraction_happened

#------------------------------------------------------

func _unhandled_input(event):
	if can_interact and event.is_action_pressed("interact"):  # Assuming 'ui_interact' is your interaction key
		signal_interraction_happened.emit()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):  # Check that the body is your player
		can_interact = true 
		hint.show()

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_interact = false
		hint.hide()
