extends CanvasLayer
class_name UI

var is_reloading: bool

"""create an array of nodes with textureRects which will
be used in the 'update_health_ui' function"""
@onready var texture_rect: TextureRect = $Control/HBoxContainer/VBoxContainer/Container/GridContainer/TextureRect
@onready var texture_rect_2: TextureRect = $Control/HBoxContainer/VBoxContainer/Container/GridContainer/TextureRect2
@onready var texture_rect_3: TextureRect = $Control/HBoxContainer/VBoxContainer/Container/GridContainer/TextureRect3
@onready var texture_rect_4: TextureRect = $Control/HBoxContainer/VBoxContainer/Container/GridContainer/TextureRect4
@onready var texture_rect_5: TextureRect = $Control/HBoxContainer/VBoxContainer/Container/GridContainer/TextureRect5

@onready var health_boxes = [texture_rect, texture_rect_2, texture_rect_3, texture_rect_4, texture_rect_5]

@onready var kills_label: Label = $Control/HBoxContainer/VBoxContainer/HBoxContainer2/HBoxContainer/ColorRect/MarginContainer/HBoxContainer/KillsLabel
@onready var fertilizer_label: Label = $Control/HBoxContainer/VBoxContainer/HBoxContainer2/HBoxContainer/ColorRect2/MarginContainer/HBoxContainer/FertilizerLabel
@onready var ammo: TextureProgressBar = $Control/HBoxContainer/ColorRect3/Ammo




#----------------------------------------------------

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func update_health_ui(current_health):
	# Loop through each health box and set visibility based on current health
	for i in range(health_boxes.size()):
		health_boxes[i].visible = i < current_health

func update_kills(new_kills):
	kills_label.text = str(new_kills)

func update_fertilizer(new_fert):
	fertilizer_label.text = str(new_fert)

func update_ammo(new_ammo):
	ammo.value = new_ammo

