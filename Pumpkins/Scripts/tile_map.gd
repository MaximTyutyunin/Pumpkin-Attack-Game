extends TileMap

@onready var tile_map: TileMap = $"."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.set_tilemap(tile_map)

