extends Camera2D

var target_zoom := Vector2(1.5, 1.5)
var target_pos := Vector2(0, 0)
var flip_vec = Vector2(1, 1)

var previous_zoom := target_zoom

var offset_cam_speed := 1.25
var zoom_cam_speed := 1.25

const MAX_ZOOM := 5
const MIN_ZOOM := 0.5

var window_mode = DisplayServer.window_get_mode()

signal hide_bar_key_pressed
signal esc_key_pressed


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	zoom -= (zoom - target_zoom) * delta * zoom_cam_speed
	#zoom = clip(zoom)
	
	offset -= (offset - target_pos) * delta * zoom.length() * offset_cam_speed

func zoom_in() -> void:
	target_zoom = clip(target_zoom + flip_vec * Vector2(0.1, 0.1))

func zoom_out() -> void:
	target_zoom = clip(target_zoom - flip_vec * Vector2(0.1, 0.1))

func flip_camera() -> void:
	flip_vec = Vector2( -1 * flip_vec[0], flip_vec[1])
	target_zoom = Vector2(-1, 1) * Vector2(target_zoom[0], target_zoom[1])
	zoom = target_zoom

func movement_zoom_in(fraction: float, pos: Vector2) -> void:
	offset_cam_speed = 1.25
	zoom_cam_speed = 1.25

	if target_zoom.length() < 4:
		target_pos = pos
		target_zoom = (1 + fraction) * 1.5 * flip_vec * Vector2(1, 1)

func movement_zoom_out() -> void:
	offset_cam_speed = 1.25
	zoom_cam_speed = 1.25
	target_pos = Vector2(0, 0)
	target_zoom = previous_zoom * flip_vec

func clip(current_zoom: Vector2) -> Vector2:
	var too_small := (current_zoom.length_squared() < 2 * MIN_ZOOM**2)
	var too_big := (current_zoom.length_squared() > 2 * MAX_ZOOM**2)
	# Clipping
	if (flip_vec[0] < 0 and too_big):
		current_zoom = Vector2(-MAX_ZOOM, MAX_ZOOM)
	elif (flip_vec[0] < 0 and too_small):
		current_zoom = Vector2(-MIN_ZOOM, MIN_ZOOM)
	elif (flip_vec[0] > 0 and too_big):
		current_zoom = Vector2(MAX_ZOOM, MAX_ZOOM)
	elif (flip_vec[0] > 0 and too_small):
		current_zoom = Vector2(MIN_ZOOM, MIN_ZOOM)
	return current_zoom

func check_if_valid_event(event: InputEvent) -> bool:
	var is_valid := false
	if event is InputEventMouseButton and (event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN):
		is_valid = true
	for key in [KEY_A, KEY_D, KEY_W, KEY_S, KEY_F]:
		if Input.is_key_pressed(key):
			is_valid = true
	return is_valid

func _input(event: InputEvent) -> void:
	#only change this if it's one of the valid events (otherwwise mosue move changes the speed)
	if check_if_valid_event(event):
		zoom_cam_speed = 1.5
		offset_cam_speed = 3.25
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		zoom_in()
	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
		zoom_out()

	if Input.is_key_pressed(KEY_A):
		target_pos += hlp.norm_to_iso(flip_vec * Vector2(-1, 0))
	if Input.is_key_pressed(KEY_D):
		target_pos += hlp.norm_to_iso(flip_vec * Vector2(1, 0))
	if Input.is_key_pressed(KEY_W):
		target_pos += hlp.norm_to_iso(flip_vec * Vector2(0, -1))
	if Input.is_key_pressed(KEY_S):
		target_pos += hlp.norm_to_iso(flip_vec * Vector2(0, 1))
	if Input.is_key_pressed(KEY_F):
		flip_camera()
	if Input.is_key_pressed(KEY_V):
		emit_signal("hide_bar_key_pressed")
	if Input.is_key_label_pressed(KEY_F11) and window_mode == DisplayServer.WINDOW_MODE_WINDOWED:
		window_mode = DisplayServer.WINDOW_MODE_FULLSCREEN
		stg.display_mode = "fullscreen"
		DisplayServer.window_set_mode(window_mode)
	elif Input.is_key_label_pressed(KEY_F11) and window_mode == DisplayServer.WINDOW_MODE_FULLSCREEN:
		window_mode = DisplayServer.WINDOW_MODE_WINDOWED
		stg.display_mode = "windowed"
		DisplayServer.window_set_mode(window_mode)
	
	if Input.is_key_label_pressed(KEY_ESCAPE):
		emit_signal("esc_key_pressed")
