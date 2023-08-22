extends Node2D

const LogicGameManager = preload("res://scenes/game/game_manager.tscn")
var game_manager := LogicGameManager.instantiate()

const colours: Array[Color] = [Color.BLANCHED_ALMOND, Color.SADDLE_BROWN]
var gfx_offset := Vector2(310, 110)
const start_x := -4
const start_y := -4

var all_pieces: Array = []

@onready var board := $board


func add_pieces_from_fen(fen_str: String) -> void:
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
			add_piece(letter, p0)
			_faction_int = -1
			x_idx += 1


func add_piece(piece_letter: String, pos: Vector2) -> void:
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
	add_pieces_from_fen(cst.full_board)
	board.apply_scale(cst.BOARD_DRAW_SCALE)
	board.play(str(cst.chosen_map))
	if cst.draw_iso == true:
		board.show()
		#pass
	else:
		board.hide()


func _init():
	add_child(game_manager)
	
