extends Camera2D

@export var min_zoom: float = 3
@export var max_zoom: float = 6
@export var zoom_delta: float = 0.1
@export var zoom_invert: bool = false

var panning
var panOrigin
var map_width_px
var map_height_px

func _ready():
	panning = false
	panOrigin = Vector2(0, 0)
	
	var hexgrid = get_node("../HexGrid")
	map_width_px = hexgrid.map_width_px
	map_height_px = hexgrid.map_height_px

	
func zoomIn():
	if zoom.x + zoom_delta <= max_zoom:
		zoom = zoom + Vector2(zoom_delta, zoom_delta)

func zoomOut():
	if zoom.x - zoom_delta >= min_zoom:
		zoom = zoom - Vector2(zoom_delta, zoom_delta)

func startManualPanning(origin: Vector2):
	panning = true
	panOrigin = origin

func stopManualPanning():
	panning = false
	position = position + offset

	if position.x < -map_width_px:
		position.x = position.x + map_width_px
	if position.x > map_width_px:
		position.x = position.x - map_width_px
	if position.y < -map_height_px:
		position.y = position.y + map_height_px
	if position.y > map_height_px:
		position.y = position.y - map_height_px
	
	offset = Vector2(0, 0)
	panOrigin = Vector2(0, 0)

func handleManualPanning(panLocation: Vector2):
	if panning:
		offset = (panOrigin - panLocation) / zoom
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if zoom_invert:
				zoomIn()
			else:
				zoomOut()
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if zoom_invert:
				zoomOut()
			else:
				zoomIn()
		if event.button_index == MOUSE_BUTTON_LEFT:
			#TODO distinguish between clicks and drags
			# clicks should highlight hexes
			# drags should pan
			if event.pressed:
				startManualPanning(event.position)
			else:
				stopManualPanning()

	elif event is InputEventMouseMotion:
		handleManualPanning(event.position)
	
	#elif event is InputEventKey:
		#if event.keycode == KEY_W:
			#if event.pressed:
