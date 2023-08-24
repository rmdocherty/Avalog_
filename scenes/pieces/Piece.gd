extends Node2D
class_name Piece

var colour: cst.colour
var turn_number: int = 1


var flat_starts := PackedVector2Array([])
var flat_ends := PackedVector2Array([])
var flat_mvs := PackedInt32Array([])
var flat_draws := PackedInt32Array([])

@onready var graphics := $GraphicalPiece
@onready var logic := $LogicPiece
@export var mixed_move_types = false


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

func reset_drag_hide_phantom(_move_confirmed: bool=false) -> void:
	$GraphicalPiece/Phantom.position = Vector2(0, 0)
	$GraphicalPiece/Sprite.stop()
	$GraphicalPiece/Phantom/PhantomSprite.hide()

func pos_from_slide(slide: Vector2, mv: Vector2, minimum_dist: Vector2, mouse_delta: Vector2) -> Vector2:
	# clamp abs of slide based on min and max possible vectors, then multiply by direction to get distance moved
	if mouse_delta.length() >= minimum_dist.length() - 0.3 * cst.LOGIC_SQ_W: # -0.2 so doesn't have to be pixel perfect
		var abs_slide = slide.abs() # we need to abs because clamp won't play nice w/ negatives
		var out = slide.normalized() * abs_slide.clamp(minimum_dist.abs(), mv.abs()).length()
		return out
	else:
		return Vector2(0, 0)

func set_logic_pos(logical_pos: Vector2) -> void:
	logic.global_position = logical_pos

func set_graphic_pos(logical_pos: Vector2) -> void:
	var norm_pos = logical_pos / cst.LOGIC_SQ_W
	graphics.global_position = hlp.norm_to_iso(cst.BOARD_DRAW_SCALE * norm_pos)

func reset_flat_arrs() -> void:
	flat_starts = PackedVector2Array([])
	flat_ends = PackedVector2Array([])
	flat_mvs = PackedInt32Array([])
	flat_draws = PackedInt32Array([])


func update_lines() -> void:
	reset_flat_arrs()
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

			flat_starts.push_back(start)
			flat_ends.push_back(end)
			flat_mvs.push_back(mv_type)
			flat_draws.push_back(draw_type)


func _ready():
	if colour == cst.colour.BLACK:
		graphics.flip_sprite()
		graphics.change_player_circle("inactive")
	set_shader_params(cst.replace_palettes)
