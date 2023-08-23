extends Node2D

const Board = preload("res://scenes/game/board/board.tscn")
var board := Board.instantiate()

var turn_number := 1
var current_turn_colour: cst.colour = cst.colour.WHITE
var chage_player_each_turn := true

var all_pieces: Array[LogicPiece] = []

func _init():
	board.init_walls(8, 8, cst.LOGIC_SQ_W * Vector2(-4, -4))
	add_child(board)

func add_pieces_from_nodes(node_list: Array[Piece]) -> void:
	for node in node_list:
		all_pieces.push_back(node.logic)

func get_moves():
	# Loop through all pieces, get valid moves, time.
	var start := Time.get_ticks_usec()
	for p in all_pieces:
		p.get_all_moves()
	#get_tree().call_group("pieces", "get_all_moves")
	var end := Time.get_ticks_usec()
	print(end - start)

func take_turn(change_player: bool=true) -> void:
	if current_turn_colour == cst.colour.WHITE and change_player:
		current_turn_colour = cst.colour.BLACK
		turn_number += 1
	elif current_turn_colour == cst.colour.BLACK and change_player:
		current_turn_colour = cst.colour.WHITE
		turn_number += 1

	get_moves()


func init() -> void:
	# Initial delay to make sure added pieces loaded
	$InitialTimer.start(0.1)

func start_game() -> void:
	$InitialTimer.queue_free()
	take_turn(false)
