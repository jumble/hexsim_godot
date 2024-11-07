extends Node

var map_width_px
var map_height_px

func _ready():
	var atlas_image_path = "res://tilesets/fantasyhextiles/fantasyhextiles_v3.png"
	var atlas_texture = load(atlas_image_path)
	
	var tile_width = 32
	var tile_height = 48
	var tile_base_height = 28
	var tile_size = tile_width * 0.5
	
	var atlas_texture_tiles_per_row = atlas_texture.get_width() / tile_width
	var atlas_texture_tiles_per_column = atlas_texture.get_height() / tile_height
	
	var tile_textures = []
	for row_index in atlas_texture_tiles_per_column:
		var row_offset = tile_height * row_index
		for col_index in atlas_texture_tiles_per_row:
			var col_offset = tile_width * col_index
			var tile_texture = AtlasTexture.new()
			tile_texture.atlas = atlas_texture
			tile_texture.region = Rect2(col_offset, row_offset, tile_width, tile_height)
			tile_textures.append(tile_texture)
	
	var tile_texture_indices = []
	var map_width_tiles = 10
	var tiles_to_fill_rows_with = [0,0,1,0,2,0,3,0,4,0,5,0,6,0,7,0,8,0]
	var map_height_tiles = tiles_to_fill_rows_with.size()
	for row_texture_index in tiles_to_fill_rows_with:
		var row_tile_texture_indices = []
		for col_index in map_width_tiles:
			row_tile_texture_indices.append(row_texture_index)
		tile_texture_indices.append(row_tile_texture_indices)
	
	#TODO math to tile this throughout the space the camera can explore?
	
	var sprite_scale = 1
	map_width_px = map_width_tiles * tile_width * 1.5 * sprite_scale
	map_height_px = map_height_tiles * tile_base_height * 0.5 * sprite_scale
	var sprite_set_origin = Vector2(-map_width_px/2.0, -map_height_px/2.0)
	
	for x_padding in [-1, 0, 1]:
		var x_offset = x_padding * map_width_px
		for y_padding in [-2, -1, 0, 1, 2]:
			var y_offset = y_padding * map_height_px
			
			var row_index = 0
			for row in tile_texture_indices:
				var col_index = 0
				for tile_texture_index in row:
					
					var sprite = Sprite2D.new()
					sprite.texture = tile_textures[tile_texture_index]
					var sprite_position_x = sprite_set_origin.x + x_offset + col_index * tile_width * 1.5 * sprite_scale
					if row_index % 2 == 1:
						sprite_position_x += 1.5 * tile_size * sprite_scale 
					var sprite_position_y = sprite_set_origin.y + y_offset +  row_index * tile_base_height * 0.5 * sprite_scale
					
					sprite.position = Vector2(sprite_position_x,  sprite_position_y)
					sprite.scale = Vector2(sprite_scale, sprite_scale)
					
					add_child(sprite)
					
					col_index += 1
				row_index += 1
