extends Node

var kills = 0
var current_scene = null
var tilemap: TileMap = null

signal signal_update_kills
signal signal_give_seed
signal signal_player_gets_hit(damage,knockback_strength, enemy_position)
#signal signal_send_tile_info(tmap: TileMap)
#----------------------------------------------------
"""GOTO: https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html#custom-scene-switcher
for more information about the following script"""
func _ready() -> void:
	var root = get_tree().root
	#root.get_child_count() - 1 gets the scene with the game 
	#instead of the autoloaded nodes
	#so that it can be used later for scene switching
	current_scene = root.get_child(root.get_child_count() - 1)

func switch_scene(res_path):
	call_deferred("_deferred_switch_scene", res_path)
	
func _deferred_switch_scene(res_path):
	"""this code switches scenes"""
	#if i dont set the node in the event bus to null with
	#      		EventBus.set_tilemap(null)
	#the follosing error will be thrown:
	#			Invalid type in function 'set_camera_limits_based_on_tilemap' 
	#			in base 'Camera2D (camera_on_player.gd)'. 
	#			The Object-derived class of argument 1 (previously freed) 
	#			is not a subclass of the expected argument class
	#this is because the tilemap will be indicated to be in the tilemap variable but it actully 
	#would be removed from memory. Godot will try to access something thats not there
	
	EventBus.set_tilemap(null)
	current_scene.free()
	var s = load(res_path)
	current_scene = s.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene

func add_kill():
	kills += 1
	if kills == 5:
		signal_give_seed.emit()
		kills = 0

"""set_tilemap and get_tilemap
are ofr the camera2d to detect the map boundaries dynamically"""
func set_tilemap(tmap: TileMap):
	tilemap = tmap
	#self.send_tile_info.emit(tilemap)

func get_tilemap() -> TileMap:
	return tilemap

