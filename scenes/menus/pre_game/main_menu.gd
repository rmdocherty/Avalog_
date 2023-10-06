extends Node2D

var inc := 0
var n_moves := 0

const move_speed :=  120.
const update_per := 7
const overflow_lim := 2000



@onready var p_layer := $Canv/HSplit/Castle/PBG/PLayer

func load_mode_select_menu(network_mode: int) -> void:
	stg.network = network_mode as cst.network_types
	hlp.load_child_remove_parent("res://scenes/menus/pre_game/mode_select_menu.tscn", self)

func load_codex() -> void:
	hlp.load_child_remove_parent("res://scenes/menus/codex/codex.tscn", self)

func load_credits() -> void:
	hlp.load_child_remove_parent("res://scenes/menus/pre_game/Credits.tscn", self)

func quit() -> void:
	get_tree().quit()

func steam_failed() -> void:
	print("foo bar")
	var warning: Control = load("res://scenes/menus/in_game/warning_modal.tscn").instantiate()
	warning.init("Steam failed to start, multiplayer won't work.", false)
	$Canv.add_child(warning)

func _init() -> void:
	steam.init_failed.connect(steam_failed )

func _process(delta: float) -> void:
	# Reset parallax layer
	inc += move_speed * delta # this should fix it for windows/faster _process calls but isn't correct
	if inc > update_per:
		p_layer.motion_offset.x += 1
		n_moves += 1
		inc = 0
	if n_moves > overflow_lim:
		print('reset!')
		n_moves = 0
		inc = 0

