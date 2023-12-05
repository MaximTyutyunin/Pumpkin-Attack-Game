extends Node2D

var can_interact = false
var is_visible = false


@onready var instructions: ColorRect = $Instructions
@onready var instructions_trigger: Area2D = $InstructionsTrigger

#---------------------------------------------------------------------

func _ready():
	instructions_trigger.connect("signal_interraction_happened", check_instructions)

func _unhandled_input(event):
	if can_interact and event.is_action_pressed("interact"):  # Assuming 'ui_interact' is your interaction key
		EventBus.switch_scene("res://Scenes/Levels/HubLevel.tscn")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):  # Check that the body is your player
		can_interact = true 

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		can_interact = false

func check_instructions():
	is_visible = !is_visible
	instructions.visible = is_visible
