extends Node

const albion_moves_class = preload("res://scenes/pieces/albion/albion_mvs.gd")
var albion_moves = albion_moves_class.new()
const rome_moves_class = preload("res://scenes/pieces/rome/rome_mvs.gd")
var rome_moves = rome_moves_class.new()
const bretagne_moves_class = preload("res://scenes/pieces/bretagne/bretagne_mvs.gd")
var bretagne_moves = bretagne_moves_class.new()
const turkiye_moves_class = preload("res://scenes/pieces/turkiye/turkiye_mvs.gd")
var turkiye_moves = turkiye_moves_class.new()
const morgana_moves_class = preload("res://scenes/pieces/morgana/morgana_mvs.gd")
var morgana_moves = morgana_moves_class.new()


"""
Plan: big nested dictionary that is indexed by faction char then piece char. Contains ref to the
piece scene, the move vectors and the logical piece scene, as well as metadata like what kind of
piece it is and therefore what lookups need to be made. For pieces with extra moves, they are
included here. For certain pieces, have code that rewrites the vectors (i.e forward) for pawns
and gets extra moves.
"""

func add_piece(faction_char: String, piece_char: String, colour: cst.colour, monarch_faction: String="a") -> Piece:
	var temp_piece = table[faction_char][piece_char]["piece"].instantiate()
	var logic_piece: LogicPiece = temp_piece.get_node("LogicPiece")
	logic_piece = set_logic_piece(logic_piece, faction_char, piece_char, colour, monarch_faction)
	return temp_piece


func add_logic_piece(faction_char: String, piece_char: String, colour: cst.colour) -> LogicPiece:
	var temp_piece: LogicPiece = table[faction_char][piece_char]["logic"].instantiate()
	temp_piece = set_logic_piece(temp_piece, faction_char, piece_char, colour)
	return temp_piece


func set_logic_piece(node: LogicPiece, faction_char: String, piece_char: String, 
					colour: cst.colour, monarch_faction: String="a") -> LogicPiece:
	# Useful for remapping a Piece's logic node in-place
	#print(faction_char, piece_char)
	# add checks here for weird pieces like pawn or king, and remappings for say aura pieces
	var temp_dict: Dictionary = table[faction_char][piece_char]
	if temp_dict.has("states"):
		var states = temp_dict["states"]
		node.mv_states = states
		node.active_mvs = states[0]
	elif temp_dict.has("mvs"):
		var mvs: Array = temp_dict["mvs"]
		node.active_mvs = mvs
	
	if temp_dict.has("ranged_dist"):
		node.ranged_dist = cst.LOGIC_SQ_W * temp_dict["ranged_dist"]
	
	if temp_dict.has("extra_moves"):
		node.extra_moves = temp_dict["extra_moves"]
	
	if faction_char == "a" and piece_char == "p":
		node = get_peasant(node, colour, monarch_faction)
	elif faction_char == "r" and piece_char == "p":
		node = get_phalanx(node, colour, monarch_faction)
	elif faction_char == "b" and piece_char == "p":
		node = get_agriculteur(node, colour, monarch_faction)
	elif faction_char == "t" and piece_char == "p":
		node = get_yaya(node, colour, monarch_faction)
	elif faction_char == "m" and piece_char == "p":
		node = get_zombie(node, colour, monarch_faction)
	
	if monarch_faction == "t" and temp_dict.has("states"):
		node = apply_turkiye_aura(node)
	
	if monarch_faction == "b":
		node = apply_bretagne_aura(node, temp_dict.has("states"))
	
	# for b aura, loop through all arrays and add Vec2(0.5) in direction
	# for t aura, loop throug all pieces w/ multi states, remap each state to
	# also include the other

	node.piece_char = piece_char
	node.faction_char = faction_char
	node.colour = colour
	return node


func apply_bretagne_aura(node: LogicPiece, states: bool) -> LogicPiece:
	var old_states: Array = []
	if states == true:
		old_states = node.mv_states
	else:
		old_states = [node.active_mvs]
	
	for state in old_states:
		for mv in state:
			for i in range(mv.N):
				var dir: Vector2 = mv.delta_arr[i].normalized()
				mv.to_arr[i] += Vector2(0.5, 0.5) * dir
				mv.delta_arr[i] += Vector2(0.5, 0.5) * dir
	return node

func apply_turkiye_aura(node: LogicPiece) -> LogicPiece:
	var old_states: Array = node.mv_states
	var new_states: Array = []
	var flat_state: Array = []
	for state in old_states:
		for mv in state:
			flat_state.push_back(mv)
	for _temp in old_states:
		new_states.push_back(flat_state)
	
	node.mv_states = new_states
	node.active_mvs = new_states[0]
	node.get_parent().mixed_move_types = true
	return node

func get_peasant(node: LogicPiece, colour: cst.colour, monarch_faction: String="a") -> LogicPiece:
	var forward := 1
	if colour == cst.colour.WHITE:
		forward = -1
	var states = albion_moves.get_pawn_moves(forward, monarch_faction)
	node.mv_states = states
	node.active_mvs = states[0]
	var extra_moves = albion_moves.get_pawn_attacks(forward)
	node.extra_moves = extra_moves
	return node


func get_phalanx(node: LogicPiece, colour: cst.colour, monarch_faction: String="a") -> LogicPiece:
	var forward := 1
	if colour == cst.colour.WHITE:
		forward = -1
	var states = rome_moves.get_pawn_moves(forward, monarch_faction)
	node.mv_states = states
	node.active_mvs = states[0]
	return node


func get_agriculteur(node: LogicPiece, colour: cst.colour, monarch_faction: String="a") -> LogicPiece:
	var forward := 1
	if colour == cst.colour.WHITE:
		forward = -1
	var states = bretagne_moves.get_pawn_moves(forward, monarch_faction)
	node.mv_states = states
	node.active_mvs = states[0]
	var extra_moves = bretagne_moves.get_pawn_attacks(forward)
	node.extra_moves = extra_moves
	return node

func get_yaya(node: LogicPiece, colour: cst.colour, monarch_faction: String="a") -> LogicPiece:
	var forward := 1
	if colour == cst.colour.WHITE:
		forward = -1
	var states = turkiye_moves.get_pawn_moves(forward, monarch_faction)
	node.mv_states = states
	node.active_mvs = states[0]
	return node
	
func get_zombie(node: LogicPiece, colour: cst.colour, monarch_faction: String="a") -> LogicPiece:
	var forward := 1
	if colour == cst.colour.WHITE:
		forward = -1
	var states = morgana_moves.get_pawn_moves(forward, monarch_faction)
	node.mv_states = states
	node.active_mvs = states[0]
	return node

var table = {
	"a": {
		"p": {
			"piece": preload("res://scenes/pieces/albion/Peasant.tscn"),
			"logic": preload("res://scenes/pieces/inherited/LogicPawn.tscn"),
			"states": albion_moves.get_pawn_moves(),
			"extra_moves": albion_moves.get_pawn_attacks()
		},
		"r": {
			"piece": preload("res://scenes/pieces/albion/Gaheris.tscn"),
			"logic": preload("res://scenes/pieces/LogicPiece.tscn"),
			"mvs": albion_moves.get_rook_moves(),
		},
		"n": {
			"piece": preload("res://scenes/pieces/albion/Rogue.tscn"),
			"logic": preload("res://scenes/pieces/LogicPiece.tscn"),
			"mvs": albion_moves.get_knight_moves(),
		},
		"b": {
			"piece": preload("res://scenes/pieces/albion/Merlin.tscn"),
			"logic": preload("res://scenes/pieces/LogicPiece.tscn"),
			"mvs": albion_moves.get_bishop_moves(),
		},
		"q": {
			"piece": preload("res://scenes/pieces/albion/Guinevere.tscn"),
			"logic": preload("res://scenes/pieces/LogicPiece.tscn"),
			"mvs": albion_moves.get_queen_moves(),
		},
		"k": {
			"piece": preload("res://scenes/pieces/albion/Arthur.tscn"),
			"logic": preload("res://scenes/pieces/inherited/Arthur.tscn"),
			"mvs": albion_moves.get_king_moves(),
			#"extra_moves": albion_moves.get_king_castling_moves()
		},
	},
	"r": {
		"p": {
			"piece": preload("res://scenes/pieces/rome/Phalanx.tscn"),
			"logic": preload("res://scenes/pieces/inherited/LogicPawn.tscn"),
			"states": rome_moves.get_pawn_moves(),
		},
		"r": {
			"piece": preload("res://scenes/pieces/rome/Elephant.tscn"),
			"logic": preload("res://scenes/pieces/LogicPiece.tscn"),
			"mvs": rome_moves.get_rook_moves(),
		},
		"n": {
			"piece": preload("res://scenes/pieces/rome/Captain.tscn"),
			"logic": preload("res://scenes/pieces/LogicPiece.tscn"),
			"mvs": rome_moves.get_knight_moves(),
		},
		"b": {
			"piece": preload("res://scenes/pieces/rome/Cardinal.tscn"),
			"logic": preload("res://scenes/pieces/LogicPiece.tscn"),
			"mvs": rome_moves.get_bishop_moves(),
		},
		"q": {
			"piece": preload("res://scenes/pieces/rome/Contessa.tscn"),
			"logic": preload("res://scenes/pieces/LogicPiece.tscn"),
			"mvs": rome_moves.get_queen_moves(),
		},
		"k": {
			"piece": preload("res://scenes/pieces/rome/Count.tscn"),
			"logic": preload("res://scenes/pieces/LogicPiece.tscn"),
			"mvs": rome_moves.get_king_moves(),
		},
	},
	"b": {
		"p": {
			"piece": preload("res://scenes/pieces/bretagne/Agriculteur.tscn"),
			"logic": preload("res://scenes/pieces/inherited/LogicPawn.tscn"),
			"states": bretagne_moves.get_pawn_moves(),
			"extra_moves": bretagne_moves.get_pawn_attacks()
		},
		"r": {
			"piece": preload("res://scenes/pieces/bretagne/Halberd.tscn"),
			"logic": preload("res://scenes/pieces/LogicPiece.tscn"),
			"mvs": bretagne_moves.get_rook_moves(),
		},
		"n": {
			"piece": preload("res://scenes/pieces/bretagne/Archer.tscn"),
			"logic": preload("res://scenes/pieces/inherited/RangedLogicPiece.tscn"),
			"mvs": bretagne_moves.get_knight_moves(),
			"ranged_dist": 2.5,
		},
		"b": {
			"piece": preload("res://scenes/pieces/bretagne/Druid.tscn"),
			"logic": preload("res://scenes/pieces/inherited/RangedLogicPiece.tscn"),
			"mvs": bretagne_moves.get_bishop_moves(),
			"ranged_dist": 3.0,
		},
		"q": {
			"piece": preload("res://scenes/pieces/bretagne/Soleil.tscn"),
			"logic": preload("res://scenes/pieces/LogicPiece.tscn"),
			"mvs": bretagne_moves.get_queen_moves()
		},
		"k": {
			"piece": preload("res://scenes/pieces/bretagne/Gradlon.tscn"),
			"logic": preload("res://scenes/pieces/LogicPiece.tscn"),
			"mvs": bretagne_moves.get_king_moves()
		},
	},
	"t": {
		"p": {
			"piece": preload("res://scenes/pieces/turkiye/Yaya.tscn"),
			"logic": preload("res://scenes/pieces/inherited/MultiStateLogicPiece.tscn"),
			"states": turkiye_moves.get_pawn_moves(),
		},
		"r": {
			"piece": preload("res://scenes/pieces/turkiye/Dardanelles.tscn"),
			"logic": preload("res://scenes/pieces/inherited/RangedLogicPiece.tscn"),
			"mvs": turkiye_moves.get_rook_moves(),
		},
		"n": {
			"piece": preload("res://scenes/pieces/turkiye/Janissary.tscn"),
			"logic": preload("res://scenes/pieces/inherited/RangedLogicPiece.tscn"),
			"states": turkiye_moves.get_knight_moves(),
			"ranged_dist": 2.0,
		},
		"b": {
			"piece": preload("res://scenes/pieces/turkiye/Vizier.tscn"),
			"logic": preload("res://scenes/pieces/LogicPiece.tscn"),
			"mvs": turkiye_moves.get_bishop_moves(),
		},
		"q": {
			"piece": preload("res://scenes/pieces/turkiye/Suleiman.tscn"),
			"logic": preload("res://scenes/pieces/inherited/MultiStateLogicPiece.tscn"),
			"states": turkiye_moves.get_queen_moves(),
		},
		"k": {
			"piece": preload("res://scenes/pieces/turkiye/Roxelena.tscn"),
			"logic": preload("res://scenes/pieces/LogicPiece.tscn"),
			"mvs": turkiye_moves.get_king_moves(),
		},
	},
	"m": {
		"p": {
			"piece": preload("res://scenes/pieces/morgana/Zombie.tscn"),
			"logic": preload("res://scenes/pieces/inherited/MultiStateLogicPiece.tscn"),
			"states": morgana_moves.get_pawn_moves(),
		},
		"r": {
			"piece": preload("res://scenes/pieces/morgana/MMC.tscn"),
			"logic": preload("res://scenes/pieces/inherited/MultiStateLogicPiece.tscn"),
			"states": morgana_moves.get_rook_moves(),
		},
		"n": {
			"piece": preload("res://scenes/pieces/morgana/Skeleton.tscn"),
			"logic": preload("res://scenes/pieces/inherited/RangedLogicPiece.tscn"),
			"mvs": morgana_moves.get_knight_moves(),
			"ranged_dist": 2.0,
		},
		"b": {
			"piece": preload("res://scenes/pieces/morgana/Shadow.tscn"),
			"logic": preload("res://scenes/pieces/LogicPiece.tscn"),
			"mvs": morgana_moves.get_bishop_moves()
		},
		"q": {
			"piece": preload("res://scenes/pieces/morgana/Mordred.tscn"),
			"logic": preload("res://scenes/pieces/LogicPiece.tscn"),
			"mvs": morgana_moves.get_queen_moves()
		},
		"k": {
			"piece": preload("res://scenes/pieces/morgana/Morgana.tscn"),
			"logic": preload("res://scenes/pieces/LogicPiece.tscn"),
			"mvs": morgana_moves.get_king_moves(),
		},
	}
}
