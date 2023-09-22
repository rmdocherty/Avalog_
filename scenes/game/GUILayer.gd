extends CanvasLayer

var hidden := false
var menu_shown := false

func _ready():
	$BottomBar/hb1/Name1.text = stg.uname_1
	$BottomBar/hb1/Name2.text = stg.uname_2
	var clocks = [$Clock1, $Clock2]
	for c in clocks:
		if stg.total_time_min < 999:
			c.init(stg.total_time_min, stg.total_time_seconds)
		else:
			c.hide()

func toggle_hide_btn(btn_pressed: bool) -> void:
	if btn_pressed:
		$HideBar.button_pressed = true
		hide_bar()
	else:
		$HideBar.button_pressed = false
		show_bar()

func toggle_hide_keypress() -> void:
	hidden = not hidden
	toggle_hide_btn(hidden)

func hide_bar(hide_btns: bool=false) -> void:
	var clocks = [$Clock1, $Clock2]
	for c in clocks:
		c.hide()
	$BottomBar.hide()
	hidden = true
	if hide_btns:
		$Settings.hide()
		$HideBar.hide()
	
func show_bar() -> void:
	var clocks = [$Clock1, $Clock2]
	for c in clocks:
		c.show()
	$BottomBar.show()
	hidden = false

func clock_stop_after_move_confirmed(current_turn_colour: int) -> void:
	"""
	# need to fix this in line with below!
	if current_turn_colour == cst.colour.WHITE:
		$Clock1.running = false
	elif current_turn_colour == cst.colour.BLACK:
		$Clock2.running = false
	"""
	
	var clocks = [$Clock1, $Clock2]
	for i in range(2):
		var color := (i + stg.player_colour) % 2 as cst.colour
		if current_turn_colour == color:
			clocks[i].running = false

func clock_start_after_move_finished(current_turn_colour: int) -> void:
	var clocks = [$Clock1, $Clock2]
	var names = [$BottomBar/hb1/Name1, $BottomBar/hb1/Name2]
	for i in range(2):
		var color := (i + stg.player_colour) % 2 as cst.colour
		var state := 0
		var clock = clocks[i]
		var panel = clock.get_node("Highlight")
		var text = names[i]
		if current_turn_colour == color:
			clock.running = true
			clock.get_node("Timer").start(1)
			state = 1
		set_colours(state, color, panel, text)
	
	"""
	if current_turn_colour == cst.colour.WHITE:
		$Clock1.running = true
		$Clock1/Timer.start(1)
	elif current_turn_colour == cst.colour.BLACK:
		$Clock2.running = true
		$Clock2/Timer.start(1)
	"""

func set_colours(state: int, color: cst.colour, panel_node: Panel, text_node: Label) -> void:
	var text_colour := Color(1., 1., 1., 1.)
	var panel_colour := Color(0.518, 0.494, 0.529) 
	if state == 1:
		text_colour = cst.faction_colours[stg.replace_palettes[color + 2]]
		panel_colour = cst.faction_colours[stg.replace_palettes[color + 2]]
	var new_sb: StyleBoxFlat = panel_node.get_theme_stylebox("panel").duplicate()
	new_sb.border_color = panel_colour
	panel_node.add_theme_stylebox_override("panel", new_sb)
	text_node.add_theme_color_override("font_color", text_colour)
