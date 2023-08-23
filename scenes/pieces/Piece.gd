extends Node2D
class_name Piece

var colour: cst.colour
@onready var graphics := $GraphicalPiece
@onready var logic := $LogicPiece


func init(logic_pos: Vector2, set_colour: cst.colour) -> void:
	colour = set_colour
	set_logic_pos(logic_pos)
	graphics_init(logic_pos, set_colour)
	

func graphics_init(logic_pos: Vector2, set_colour: cst.colour) -> void:
	set_graphic_pos(logic_pos)
	if set_colour == cst.colour.BLACK:
		graphics.flip_sprite()
		graphics.change_player_circle("inactive")
	set_shader_params(cst.replace_palettes)

func set_shader_params(replace_palettes):
	graphics.material.set_shader_parameter("original_palette_num", replace_palettes[colour])
	graphics.material.set_shader_parameter("replace_palette_num", replace_palettes[colour + 2])


func set_logic_pos(logical_pos: Vector2) -> void:
	logic.global_position = logical_pos

func set_graphic_pos(logical_pos: Vector2) -> void:
	var norm_pos = logical_pos / cst.LOGIC_SQ_W
	graphics.global_position = hlp.norm_to_iso(cst.BOARD_DRAW_SCALE * norm_pos)


func update_lines() -> void:
	var mvs: Array = logic.active_mvs
	var nested_vms: Array = logic.nested_valid_moves
	var N_vm := len(nested_vms)
	var N_mvs := len(mvs)
	for i in range(N_vm):
		var mv_type: cst.mv_type
		var draw_type: cst.draw_type
		if i < N_mvs:
			mv_type = mvs[i].move_type
			draw_type = mvs[i].draw_type
		else: # this is for extra moves
			mv_type = cst.mv_type.NORMAL
			draw_type = cst.draw_type.LINE
		var starts: Array[Vector2] = nested_vms[i][0]
		var ends: Array[Vector2] = nested_vms[i][1]
		for j in range(len(starts)):
			var start: Vector2 = starts[j]
			var end: Vector2 = ends[j]
			graphics.update_lines_from_fragment(mv_type, draw_type, start, end)

func _ready():
	if colour == cst.colour.BLACK:
		graphics.flip_sprite()
		graphics.change_player_circle("inactive")
	set_shader_params(cst.replace_palettes)
