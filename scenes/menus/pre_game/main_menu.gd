extends Node2D

var inc := 0
const update_per := 7
const overflow_lim := 2000

@onready var p_layer := $Canv/HSplit/Castle/PBG/PLayer

func load_mode_select_menu(network_mode: int) -> void:
	cst.network = network_mode as cst.network_types
	cst.load_child_remove_parent("res://scenes/menus/pre_game/mode_select_menu.tscn", self)

func load_codex() -> void:
	cst.load_child_remove_parent("res://scenes/menus/codex/codex.tscn", self)

func _process(_delta: float) -> void:
	inc += 1
	if inc % update_per == 0:
		p_layer.motion_offset.x += 1
	if inc > overflow_lim:
		inc = 0
