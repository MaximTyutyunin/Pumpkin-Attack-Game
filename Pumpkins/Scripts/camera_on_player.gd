extends Camera2D

#var tilemap: TileMap = null

#-----------------------------------------------------------------


func _ready():
	var tilemap = EventBus.get_tilemap()
	if tilemap:
		set_camera_limits_based_on_tilemap(tilemap)
	else:
		print("TileMap not found in EventBus")

func set_camera_limits_based_on_tilemap(tilemap: TileMap):
	var used_rect = tilemap.get_used_rect() # this is the entire map in the game simplified to a square
	#var tile_size =  tilemap.cell_quadrant_size # this is the size of each square of the tileset --> cell_quadrant_size

	# Calculate the world coordinates from the TileMap's used rectangle
	limit_left = used_rect.position.x * 16 # * tile_size.x
	limit_top = used_rect.position.y * 16 #* tile_size.y
	limit_right = (used_rect.end.x) * 16# * tile_size.x
	limit_bottom = (used_rect.end.y)* 16 # * tile_size.y

