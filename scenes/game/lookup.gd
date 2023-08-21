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

func add_logic_piece(faction_char: String, piece_char: String, colour: cst.colour) -> LogicPiece:
	var temp_piece: LogicPiece = table[faction_char][piece_char]["logic"].instantiate()
	temp_piece = set_logic_piece(temp_piece, faction_char, piece_char, colour)
	return temp_piece


func set_logic_piece(node: LogicPiece, faction_char: String, piece_char: String, colour: cst.colour) -> LogicPiece:
	# add checks here for weird pieces like pawn or king, and remappings for say aura pieces
	var temp_dict: Dictionary = table[faction_char][piece_char]
	if temp_dict.has("states"):
		var states = temp_dict["states"]
		print(faction_char, piece_char)
		node.mv_states = states
		node.active_mvs = states[0]
	elif temp_dict.has("mvs"):
		var mvs: Array = temp_dict["mvs"]
		node.active_mvs = mvs
	
	if temp_dict.has("extra_moves"):
		node.extra_moves = temp_dict["extra_moves"]

	node.piece_char = piece_char
	node.faction_char = faction_char
	node.colour = colour

	return node


func get_peasant(node: LogicPiece, colour: cst.colour) -> LogicPiece:
	var forward := 1
	if colour == cst.colour.WHITE:
		forward = -1
	var states = albion_moves.get_pawn_moves(forward)
	node.mv_states = states
	node.active_mvs = states[0]
	node.extra_moves = table["a"]["p"]["extra_moves"]
	return node


var table = {
	"a": {
		"p": {
			"piece": "",
			"logic": preload("res://scenes/pieces/inherited/Peasant.tscn"),
			"states": albion_moves.get_pawn_moves(),
			"extra_moves": albion_moves.get_pawn_attacks()
		},
		"r": {
			"piece": "",
			"logic": preload("res://scenes/pieces/LogicPiece.tscn"),
			"mvs": albion_moves.get_rook_moves(),
		},
		"n": {
			"piece": "",
			"logic": preload("res://scenes/pieces/LogicPiece.tscn"),
			"mvs": albion_moves.get_knight_moves(),
		},
		"b": {
			"piece": "",
			"logic": preload("res://scenes/pieces/LogicPiece.tscn"),
			"mvs": albion_moves.get_bishop_moves(),
		},
		"q": {
			"piece": "",
			"logic": preload("res://scenes/pieces/LogicPiece.tscn"),
			"mvs": albion_moves.get_queen_moves(),
		},
		"k": {
			"piece": "",
			"logic": preload("res://scenes/pieces/LogicPiece.tscn"),
			"mvs": albion_moves.get_king_moves(),
			#"extra_moves": albion_moves.get_king_castling_moves()
		},
	},
}
