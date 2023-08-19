extends Node

const albion_moves_class = preload("res://scenes/pieces/albion/albion_mvs.gd")
var albion_moves = albion_moves_class.new()


"""
Plan: big nested dictionary that is indexed by faction char then piece char. Contains ref to the
piece scene, the move vectors and the logical piece scene, as well as metadata like what kind of
piece it is and therefore what lookups need to be made. For pieces with extra moves, they are
included here. For certain pieces, have code that rewrites the vectors (i.e forward) for pawns
and gets extra moves.
"""


func get_logic_piece(faction_char: String, piece_char: String, colour: cst.colour) -> LogicPiece:
	# add checks here for weird pieces like pawn or king, and remappings for say aura pieces
	var temp = table[faction_char][piece_char]["logic"]
	var node: LogicPiece = temp.instantiate()
	var mv_states: Array = table[faction_char][piece_char]["states"]
	if piece_char == "p":
		mv_states = remap_symmetric_vectors(colour)
	
	node.piece_char = piece_char
	node.faction_char = faction_char
	node.colour = colour
	node.mv_states = mv_states
	node.active_mvs = mv_states[0]
	return node

func remap_symmetric_vectors(colour: cst.colour) -> Array:
	# TODO: adjust for different piece types
	var forward := 1
	if colour == cst.colour.WHITE:
		forward = -1
	return albion_moves.get_pawn_moves(forward)

var table = {
	"a": {
		"p": {
			"piece": "",
			"logic": preload("res://scenes/pieces/LogicPiece.tscn"),
			"states": albion_moves.get_pawn_moves(),
			"extra_moves": albion_moves.get_pawn_attacks()
		},
		"r": {
			"piece": "",
			"logic": preload("res://scenes/pieces/LogicPiece.tscn"),
			"states": albion_moves.get_rook_moves(),
		},
		"n": {
			"piece": "",
			"logic": preload("res://scenes/pieces/LogicPiece.tscn"),
			"states": albion_moves.get_knight_moves(),
		},
		"b": {
			"piece": "",
			"logic": preload("res://scenes/pieces/LogicPiece.tscn"),
			"states": albion_moves.get_bishop_moves(),
		},
		"q": {
			"piece": "",
			"logic": preload("res://scenes/pieces/LogicPiece.tscn"),
			"states": albion_moves.get_queen_moves(),
		},
		"k": {
			"piece": "",
			"logic": preload("res://scenes/pieces/LogicPiece.tscn"),
			"states": albion_moves.get_king_moves(),
			"extra_moves": albion_moves.get_king_castling_moves()
		},
	},
}
