extends Node2D

const LogicGameManager = preload("res://scenes/game/game_manager.tscn")
var game_manager := LogicGameManager.instantiate()

const colours: Array[Color] = [Color.BLANCHED_ALMOND, Color.SADDLE_BROWN]
var gfx_offset := Vector2(310, 110)
const start_x := -4
const start_y := -4

var all_pieces: Array[Piece] = []
var selected_piece: Piece

@onready var board := $board


func add_pieces_from_fen(fen_str: String) -> Array[Piece]:
	var pieces: Array[Piece] = []
	var x_idx: int = start_x
	var y_idx: int = start_y
	var _faction_int: int = -1
	for letter in fen_str:
		var p0 := Vector2((x_idx + 0.5) * cst.LOGIC_SQ_W, (y_idx + 0.5) * cst.LOGIC_SQ_W)
		if letter == '/':
			y_idx += 1
			x_idx = start_x
		elif letter.is_valid_int():
			x_idx += int(letter)
		elif letter in cst.fen_faction_lookup:
			_faction_int = cst.fen_faction_lookup.find(letter, 0)
		else:
			var piece: Piece = add_piece(letter, p0)
			pieces.push_back(piece)
			_faction_int = -1
			x_idx += 1
	return pieces

func add_piece(piece_letter: String, pos: Vector2) -> Piece:
	var colour: cst.colour
	var piece_type: String = piece_letter.to_lower()
	if (piece_letter == piece_type):
		colour = cst.colour.BLACK
	else:
		colour = cst.colour.WHITE
	
	var temp_piece = lkp.add_piece("a", piece_type, colour)
	add_child(temp_piece)
	temp_piece.init(pos, colour)
	all_pieces.push_back(temp_piece)
	return temp_piece

func init(fen: String) -> void:
	all_pieces = add_pieces_from_fen(fen)
	game_manager.add_pieces_from_nodes(all_pieces)
	game_manager.init()
	$InitialTimer.start()


func start_game() -> void:
	for p in all_pieces:
		p.update_lines()


func take_turn(change_player: bool=true) -> void:
	var _foo = game_manager.take_turn(change_player)
	for p in all_pieces: # we can assign whether or not turn matches here
		p.update_lines()
		p.turn_number = game_manager.turn_number


func reset_piece_drag() -> void:
	selected_piece.reset_drag_hide_phantom()
	hide_buttons()

func _unhandled_input(_event: InputEvent) -> void:
	if not selected_piece:
		return
	var gfx: GraphicalPiece = selected_piece.get_node("GraphicalPiece")
	var phantom = gfx.get_node("Phantom")
	if Input.is_action_just_released("click") and phantom.dragging:
		phantom.dragging = false
		gfx.hide_lines()
		print("released")
		show_buttons()
	elif Input.is_action_just_pressed("click"):
		if phantom.dragging == false:
			gfx.hide_lines()
			reset_piece_drag()

func show_buttons() -> void:
	var global_pos = selected_piece.get_node("GraphicalPiece/Phantom").global_position
	var i := 0
	var y_pos := [-28, -8]
	for btn in [$ConfirmMove, $RejectMove]:
		btn.global_position = global_pos + Vector2(16, y_pos[i])
		btn.show()
		if $Camera2D.flip_vec[0] == -1:
			btn.flip_h = true
		else:
			btn.flip_h = false
		i += 1

func hide_buttons() -> void:
	$ConfirmMove.hide()
	$RejectMove.hide()

func draw_flat_board(h: int, w: int) -> void:
	# Loop and draw coloured rectangles
	for y in range(h):
		for x in range(w):
			var colour := colours[(x + y) % 2]
			var p0 := cst.LOGIC_SQ_W * cst.FLAT_DRAW_SCALE * Vector2(x, y) + gfx_offset
			const size := cst.LOGIC_SQ_W * cst.FLAT_DRAW_SCALE * Vector2(1, 1)
			var rect := Rect2(p0, size)
			draw_rect(rect, colour)

func _draw() -> void:
	if cst.draw_iso == false:
		draw_flat_board(8, 8)

func _ready() -> void:
	board.apply_scale(cst.BOARD_DRAW_SCALE)
	board.play(str(cst.chosen_map))
	if cst.draw_iso == true:
		board.show()
		pass
	else:
		board.hide()

func _init():
	add_child(game_manager)

