extends Node2D
class_name Piece

var colour: cst.colour
var turn_number: int = 1

var moving := false
var total_moved := Vector2(0, 0)
var to_move := Vector2(0, 0)
var moving_to_attack := false


var flat_starts := PackedVector2Array([])
var flat_ends := PackedVector2Array([])
var flat_mvs := PackedInt32Array([])
var flat_draws := PackedInt32Array([])

@onready var graphics: GraphicalPiece = $GraphicalPiece
@onready var logic: LogicPiece = $LogicPiece
@export var mixed_move_types = false
@export var faction_char: String = "a"
@export var piece_char: String = "p"
@export var piece_vel: float = 1.


# ======================== INIT LOGIC =================
func init(logic_pos: Vector2, set_colour: cst.colour) -> void:
	colour = set_colour
	set_logic_pos(logic_pos)
	graphics_init(logic_pos, set_colour)

func logic_init(logic_pos: Vector2) -> void:
	set_logic_pos(logic_pos)
	logic.piece_char = piece_char
	logic.faction_char = faction_char
	
func graphics_init(logic_pos: Vector2, set_colour: cst.colour) -> void:
	set_graphic_pos(logic_pos)
	if set_colour == cst.colour.BLACK:
		graphics.flip_sprite()
		graphics.change_player_circle("inactive")
	set_shader_params(cst.replace_palettes)

# ======================== GFX LOGIC =================
func set_shader_params(replace_palettes) -> void:
	graphics.material.set_shader_parameter("original_palette_num", replace_palettes[colour])
	graphics.material.set_shader_parameter("replace_palette_num", replace_palettes[colour + 2])

func reset_drag_hide_phantom(_move_confirmed: bool=false) -> void:
	$GraphicalPiece/Phantom.position = Vector2(0, 0)
	$GraphicalPiece/Sprite.stop()
	$GraphicalPiece/Phantom/PhantomSprite.hide()

func reset_flat_arrs() -> void:
	graphics.reset_lines()
	flat_starts = PackedVector2Array([])
	flat_ends = PackedVector2Array([])
	flat_mvs = PackedInt32Array([])
	flat_draws = PackedInt32Array([])

func update_lines(nested_vms: Array) -> void:
	"""For each valid move in nested_valid_moves (and each vector in that), loop through and create
	appropriate visual (line or append point to polygon etc), storing the values in flat arrays which
	are then used for phantom move matching. It also accounts for extra moves."""
	reset_flat_arrs()
	var mvs: Array = logic.active_mvs
	#var nested_vms: Array = logic.nested_valid_moves
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
			
			if start.length() < end.length(): # stop moving matching w/ 0 vecs
				flat_starts.push_back(start)
				flat_ends.push_back(end)
				flat_mvs.push_back(mv_type)
				flat_draws.push_back(draw_type)


# ======================== MOVE LOGIC =================
func pos_from_slide(slide: Vector2, mv: Vector2, minimum_dist: Vector2, mouse_delta: Vector2) -> Vector2:
	# Clamp abs of slide based on min and max possible vectors, then multiply by direction to get distance moved
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

func move_piece() -> Vector2:
	var move_dist: Vector2 = graphics.get_node("Phantom").logic_pos
	var current_logic_pos: Vector2 = logic.global_position
	var new_logic_pos: Vector2 = current_logic_pos + move_dist
	logic.move(new_logic_pos)
	set_graphic_pos(new_logic_pos)
	post_move(new_logic_pos)
	return new_logic_pos

func post_move(_delta: Vector2) -> void:
	# Overwritten later
	pass

func change_turn(new_turn_number: int) -> void:
	turn_number = new_turn_number
	var turn_matches: bool = (new_turn_number + 1) % 2 == colour
	if turn_matches:
		graphics.change_player_circle("active")
	else:
		graphics.change_player_circle("inactive")

# ======================== PROCESSES =================
func _ready():
	if colour == cst.colour.BLACK:
		graphics.flip_sprite()
		graphics.change_player_circle("inactive")
	set_shader_params(cst.replace_palettes)

func _process(delta):
	if moving:
		var current_dist: float = total_moved.length()
		var whole_dist: float =  to_move.length()
		if current_dist < whole_dist:
			var norm_dist := (whole_dist - current_dist) / whole_dist
			var moved_along := 0.3 + norm_dist
			var moved = total_moved.normalized() * delta * piece_vel * moved_along * cst.ANIM_SPEED
			moved.clamp(cst.LOGIC_SQ_W * Vector2(0.25,0.25), cst.LOGIC_SQ_W * Vector2(1,1))
			global_position += moved
			total_moved += moved
			set_graphic_pos(global_position)
			
			if current_dist > whole_dist / 2 and moving_to_attack:
				pass # do camera zoom in
		elif current_dist >= whole_dist:
			moving = false
			moving_to_attack = false
			
		
