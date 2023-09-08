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

func hide_bar() -> void:
	var clocks = [$Clock1, $Clock2]
	for c in clocks:
		c.hide()
	$BottomBar.hide()
	hidden = true
	
func show_bar() -> void:
	var clocks = [$Clock1, $Clock2]
	for c in clocks:
		c.show()
	$BottomBar.show()
	hidden = false

func clock_stop_after_move_confirmed(current_turn_colour: int) -> void:
	if current_turn_colour == cst.colour.WHITE:
		$Clock1.running = false
	elif current_turn_colour == cst.colour.BLACK:
		$Clock2.running = false

func clock_start_after_move_finished(current_turn_colour: int) -> void:
	if current_turn_colour == cst.colour.WHITE:
		$Clock1.running = true
		$Clock1/Timer.start(1)
	elif current_turn_colour == cst.colour.BLACK:
		$Clock2.running = true
		$Clock2/Timer.start(1)
