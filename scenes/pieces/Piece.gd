extends Node2D
class_name Piece

var colour: cst.colour
var turn_number: int = 1
var piece_n: int = 0

var moving := false
var total_moved := Vector2(0, 0)
var to_move := Vector2(0, 0)
var moving_to_attack := false
var move_ended := false


var flat_starts := PackedVector2Array([])
var flat_ends := PackedVector2Array([])
var flat_mvs := PackedInt32Array([])
var flat_draws := PackedInt32Array([])

@onready var graphics: GraphicalPiece = $GraphicalPiece
@onready var logic: LogicPiece = $LogicPiece
@onready var gfx_manager = get_parent()

@export var mixed_move_types = false
@export var faction_char: String = "a"
@export var piece_char: String = "p"
@export var piece_vel: float = 1.5 * cst.LOGIC_SQ_W


# ======================== INIT LOGIC =================
func init(logic_pos: Vector2, set_colour: cst.colour, n: int) -> void:
	colour = set_colour
	piece_n = n
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
	set_shader_params(stg.replace_palettes)

# ======================== GFX LOGIC =================
func set_shader_params(replace_palettes: Array[int]) -> void:
	graphics.material.set_shader_parameter("original_palette_num", replace_palettes[colour])
	graphics.material.set_shader_parameter("replace_palette_num", replace_palettes[colour + 2])

func reset_drag_hide_phantom(_move_confirmed: bool=false) -> void:
	$GraphicalPiece/Phantom.position = Vector2(0, 0)
	$GraphicalPiece/Icon.position = Vector2(0, 0)
	$GraphicalPiece/Phantom.dragging = false
	$GraphicalPiece/Phantom/PhantomSprite.hide()

func reset_flat_arrs() -> void:
	graphics.delete_lines()
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

func play_attack_anim() -> void:
	var sprite: AnimatedSprite2D = graphics.sprite
	sprite.play(graphics.attack_anim)
	await sprite.animation_looped
	sprite.play(graphics.passive_anim)
	sprite.stop()

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

func set_graphic_pos(logical_pos: Vector2, iso: bool=true) -> void:
	var norm_pos = logical_pos / cst.LOGIC_SQ_W
	if iso:
		graphics.global_position = hlp.norm_to_iso(cst.BOARD_DRAW_SCALE * norm_pos)
	else:
		graphics.global_position = logical_pos

func move_piece(move_dist: Vector2) -> Vector2:
	move_ended = false
	# can add a check here if the phantom has overlapping areas & set moving to attack
	var current_logic_pos: Vector2 = logic.global_position
	var new_logic_pos: Vector2 = current_logic_pos + move_dist
	logic.move(new_logic_pos)
	reset_drag_hide_phantom()
	if stg.ANIM_ON:
		$Audio/Move.play()
		var sprite: AnimatedSprite2D = graphics.sprite
		sprite.play(graphics.passive_anim)
		total_moved = Vector2(0, 0)
		to_move = move_dist
		moving = true
	else:
		set_graphic_pos(new_logic_pos)
		post_move(new_logic_pos)
		gfx_manager.after_piece_finished_moving()
	return new_logic_pos

func post_move(_delta: Vector2) -> void:
	# Overwritten later
	pass

func change_turn(new_turn_number: int) -> void:
	turn_number = new_turn_number
	var online: bool = stg.network == cst.network_types.ONLINE
	var turn_matches: bool = (new_turn_number + 1) % 2 == colour
	var your_turn: bool = stg.player_colour == (new_turn_number + 1) % 2
	var your_piece: bool = stg.player_colour == colour
	if turn_matches and not online:
		graphics.change_player_circle("active")
	elif not turn_matches and not online:
		graphics.change_player_circle("inactive")
	elif not your_turn and your_piece and online:
		graphics.change_player_circle("paused")
	elif your_turn and your_piece and online:
		graphics.change_player_circle("active")
	elif not your_piece and online:
		graphics.change_player_circle("inactive")
	

func post_gfx_move() -> void:
	move_ended = true
	$Audio/Move.stop()
	if moving_to_attack:
		$Audio/AttackDelay.start()
		await play_attack_anim()
	var sprite: AnimatedSprite2D = graphics.sprite
	sprite.play(graphics.passive_anim)
	sprite.stop()

	moving = false
	moving_to_attack = false
	gfx_manager.after_piece_finished_moving()

func invalid_audio() -> void:
	$Audio/Invalid.play()

# ======================== PROCESSES =================
func _ready():
	if colour == cst.colour.BLACK:
		graphics.flip_sprite()
		graphics.change_player_circle("inactive")
	set_shader_params(stg.replace_palettes)

func _process(delta: float) -> void:
	"""If the piece's moved distance has been set, move it along until it reaches that distance with 
	a speed that ramps down. If more than halfway and it's attacking, start the camera zoom. Once 
	moving is finished, tell the game manager to do the post move function(s)."""
	if moving:
		moving_to_attack = (logic.state == logic.states.ATTACKING)
		var current_dist: float = total_moved.length()
		var whole_dist: float =  to_move.length()
		if current_dist < whole_dist:
			var norm_dist := (whole_dist - current_dist) / whole_dist
			var moved_along := 0.3 + norm_dist
			var moved := to_move.normalized() * delta * piece_vel * moved_along * stg.ANIM_SPEED * 1.6
			moved.clamp(cst.LOGIC_SQ_W * Vector2(0.25,0.25), cst.LOGIC_SQ_W * Vector2(1,1))
			total_moved += moved

			var g_pos: Vector2
			if stg.draw_iso:
				g_pos = hlp.norm_to_iso(cst.BOARD_DRAW_SCALE * moved / cst.LOGIC_SQ_W)
			else:
				g_pos = moved
			graphics.global_position += g_pos
			
			if current_dist > whole_dist / 2 and moving_to_attack and whole_dist > 100 :
				# dynamic zoom
				var move_frac := current_dist / whole_dist
				var camera: Camera2D = gfx_manager.get_node("Camera2D")
				camera.movement_zoom_in(move_frac, graphics.global_position)
		elif current_dist >= whole_dist and move_ended == false:
			post_gfx_move()
