extends Node2D

const Board = preload("res://scenes/game/board/board.tscn")
var board := Board.instantiate()

var all_pieces: Array[LogicPiece] = []


func _init():
	board.init_walls(8, 8, cst.LOGIC_SQ_W * Vector2(-4, -4))
	add_child(board)

func add_pieces_from_nodes(node_list: Array) -> void:
	for node in node_list:
		all_pieces.push_back(node.get_node("LogicPiece"))
