extends Control

signal gfx_changed

var init_vol := stg.master_vol
var shown := false
var prev_master_vol := 1.

func _ready() -> void:
	var values: Array = [stg.display_mode, stg.ANIM_ON, stg.ANIM_SPEED, 1, stg.LINE_DRAW_WIDTH, false, stg.master_vol, stg.music_vol, stg.effects_vol]
	var names: Array[String] = ["Fullscreen", "Anims", "AnimSpeed", "SpriteSize", "LineWidth", "Mute", "Master", "Music", "Effects"]
	
	for i in range(len(values)):
		var tab := "/Graphics/v/" if i < 5 else "/Sound/v/"
		var node_path := "Outer/Contents/Bar/Container" + tab + names[i] + "/HSlider"
		var node: Control = get_node(node_path)
		set_state(node, values[i])
	
func set_state(node: Control, value) -> void:
	if value is float:
		node.value = value
	elif value is bool:
		node.button_pressed = value
	elif value is String:
		var val = 0 if value == "windowed" else 1
		node.selected = val

# ======================== GAME ========================
func show_self() -> void:
	shown = true
	show()

func back() -> void:
	Music.switch_tracks(Music.tracks.MENU)
	var home_menu = load("res://scenes/menus/pre_game/main_menu.tscn").instantiate()
	#get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")
	get_parent().get_parent().back()
	get_tree().get_root().add_child(home_menu)
	get_tree().get_root().remove_child(get_parent().get_parent())

func _on_color_rect_gui_input(_event: InputEvent) -> void:
	var is_click: bool = Input.is_action_just_pressed("click")
	if is_click:
		shown = false
		hide()

func esc_pressed() -> void:
	if shown == true:
		shown = false
		hide()
	else:
		shown = true
		show()

func close_pressed() -> void:
	shown = false
	hide()

func quit() -> void:
	get_tree().quit()

# ======================== GRAPHICS ========================
func set_display_mode(option: int) -> void:
	if option == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		stg.display_mode = "fullscreen"
	elif option == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		stg.display_mode = "windowed"

func toggle_anims(button_state: bool) -> void:
	stg.ANIM_ON = button_state

func set_anim_speed(value: float) -> void:
	stg.ANIM_SPEED = value

func set_sprite_size(value: float) -> void:
	stg.PIECE_DRAW_SCALE = value * 2.2 * Vector2(1, 1)
	gfx_changed.emit()

func set_line_width(value: float) -> void:
	stg.LINE_DRAW_WIDTH = value
	gfx_changed.emit()

# ======================== SOUND ========================
func change_volume(value: float, bus_name: String) -> void:
	var bus := AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(bus, linear_to_db(value))
	

func mute(button_state: bool) -> void:
	if button_state == true:
		prev_master_vol = stg.master_vol
		stg.master_vol = 0
		change_volume(0, "Master")
	else:
		stg.master_vol = prev_master_vol
		change_volume(prev_master_vol, "Master")

func set_master_vol(value: float) -> void:
	stg.master_vol = value
	change_volume(value, "Master")

func set_music_vol(value: float) -> void:
	stg.music_vol = value
	change_volume(value, "music")

func set_effects_vol(value: float) -> void:
	stg.effects_vol = value
	change_volume(value, "sfx")
