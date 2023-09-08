extends CanvasLayer

var hidden := false
var menu_shown := false

func _ready():
	$BottomBar/hb1/Name1.text = cst.uname_1
	$BottomBar/hb1/Name2.text = cst.uname_2
	var clocks = [$Clock1, $Clock2]
	for c in clocks:
		if cst.total_time_min < 999:
			c.init(cst.total_time_min, cst.total_time_seconds)
		else:
			c.hide()

func toggle_hide_btn(btn_pressed: bool) -> void:
	if btn_pressed:
		$HideBar.button_pressed = true
		hide_bar()
	else:
		show_bar()

func hide_bar() -> void:
	$BottomBar.hide()
	hidden = true
	
func show_bar() -> void:
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
