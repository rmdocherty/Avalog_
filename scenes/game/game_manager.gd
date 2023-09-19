extends Node2D


const Board = preload("res://scenes/game/board/board.tscn")
var board := Board.instantiate()

var turn_number := 1
var current_turn_colour: cst.colour = cst.colour.WHITE
var chage_player_each_turn := true

var all_pieces: Array[LogicPiece] = []
var alive_pieces: Array[LogicPiece] = []

func _init():
	board.init_walls(8, 8, cst.LOGIC_SQ_W * Vector2(-4, -4))
	add_child(board)

func add_pieces_from_nodes(node_list: Array[Piece]) -> void:
	for node in node_list:
		all_pieces.push_back(node.logic)

func alive_filter(p: LogicPiece):
	return p.state != p.states.DEAD

func get_moves():
	# Loop through all pieces, get valid moves, time.
	var start := Time.get_ticks_usec()
	alive_pieces = all_pieces.filter(alive_filter)
	for p in alive_pieces:
		p.state = p.states.IDLE
		p.get_all_moves()
		# need to check here (as opposed to when moved) to avoid double taking when promoting whilst taking
		var promote: bool = check_for_promotion(p, p.global_position)
		if promote:
			var new_logic = promote_piece(p, p.global_position)
			new_logic.get_all_moves()
	var end := Time.get_ticks_usec()
	print(end - start)

func take_turn(change_player: bool=true) -> int:
	if current_turn_colour == cst.colour.WHITE and change_player:
		current_turn_colour = cst.colour.BLACK
		turn_number += 1
	elif current_turn_colour == cst.colour.BLACK and change_player:
		current_turn_colour = cst.colour.WHITE
		turn_number += 1

	get_moves()
	return turn_number

func move_piece(piece: Piece, move_dist: Vector2) -> void:
	piece.move_piece(move_dist)

func check_for_promotion(piece: LogicPiece, pos: Vector2) -> bool:
	if piece.piece_char != "p":
		return false
	var is_white: bool = piece.colour == cst.colour.WHITE
	var is_black: bool = piece.colour == cst.colour.BLACK
	if is_white and pos[1] < cst.LOGIC_SQ_W * (cst.Y_OFFSET + 1):
		return true
	elif is_black and pos[1] > cst.LOGIC_SQ_W * ((cst.Y_OFFSET + 8) - 1.5):
		return true
	else:
		return false

func promote_piece(piece: LogicPiece, pos: Vector2, gfx: bool=true) -> LogicPiece:
	var new_piece: Piece = lkp.add_piece(piece.faction_char, "q", piece.colour)
	piece.state = piece.states.MOVED
	if gfx:
		get_parent().add_child(new_piece)
		new_piece.hide()
		new_piece.init(pos, piece.colour, len(all_pieces))
		get_parent().all_pieces.push_back(new_piece)
		all_pieces.push_back(new_piece.logic)
	piece.delete()
	return new_piece.logic

func init() -> void:
	# Initial delay to make sure added pieces loaded
	$InitialTimer.start(0.1)

func start_game() -> void:
	$InitialTimer.queue_free()
	take_turn(false)
