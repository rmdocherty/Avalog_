extends Node2D

const Board = preload("res://scenes/game/board/board.tscn")
var board = Board.instantiate()

var all_pieces: Array[LogicPiece] = []

const temp_offset := Vector2(300, 150)


#============INIT BOARD============
func add_pieces_from_fen(fen_str: String) -> void:
	var x_idx: int = 0
	var y_idx: int = 0
	var faction_int: int = -1
	for letter in fen_str:
		var p0 := Vector2(x_idx * cst.LOGIC_SQ_W + temp_offset.x, y_idx * cst.LOGIC_SQ_W + temp_offset.y)
		if letter == '/':
			y_idx += 1
			x_idx = 0
		elif letter.is_valid_int():
			x_idx += int(letter)
		elif letter in cst.fen_faction_lookup:
			faction_int = cst.fen_faction_lookup.find(letter, 0)
		else:
			add_piece(letter, p0)
			faction_int = -1
			x_idx += 1


func add_piece(piece_letter: String, pos: Vector2) -> void:
	var colour: cst.colour
	var piece_type: String = piece_letter.to_lower()
	if (piece_letter == piece_type):
		colour = cst.colour.BLACK
	else:
		colour = cst.colour.WHITE
	var temp_piece: LogicPiece = lkp.get_logic_piece("a", piece_type, colour)
	temp_piece.position = pos
	add_child(temp_piece)
	all_pieces.push_back(temp_piece)
 

func _init():
	board.init_walls(8, 8, temp_offset)
	add_child(board)
	add_pieces_from_fen(cst.full_board)


func _ready():
	var start_t := Time.get_ticks_usec()
	for p in all_pieces:
		p.get_all_moves()
	var end_t := Time.get_ticks_usec()
	print(end_t - start_t)
