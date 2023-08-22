extends Node2D

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


func _ready():
	#set_graphic_pos(position)
	if colour == cst.colour.BLACK:
		graphics.flip_sprite()
		graphics.change_player_circle("inactive")
	set_shader_params(cst.replace_palettes)
