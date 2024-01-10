extends Node2D

var intro_nodes: Array = []
var p1_a_nodes: Array = []
var p1_b_nodes: Array = []
var p1_pieces: Array[String] = []

var p2_a_nodes: Array = []
var p2_b_nodes: Array = []
var p2_pieces: Array[String] = []

var current_nodes: Array = intro_nodes

var n_plays := 0
signal finished

const default_vol_db := -15
const default_vol_linear := db_to_linear(default_vol_db)
var FADE_TIME := 2
const zero_vol_db := db_to_linear(0)

var initial_fen: String = ""

var factions: Array[String] = ["albion", "rome", "bretagne", "turkiye", "morgana"]

func reset_arrs() -> void:
	intro_nodes = []
	p1_a_nodes = []
	p1_b_nodes = []
	p1_pieces = []

	p2_a_nodes = []
	p2_b_nodes = []
	p2_pieces = []

func get_faction(faction: int, colour: int) -> String:
	if faction == -1:
		faction = stg.chosen_factions[colour]
	var faction_name: String = factions[faction]
	return faction_name

func get_stem(faction: String, type: String, piece_char: String, number: int) -> AudioStreamPlayer:
	if piece_char in ["q", "k"] and number > 1:
		number = 1
	elif piece_char in ["r", "b", "n"] and number > 2:
		number = 1 + number % 2
	elif piece_char in ["p"] and number > 8:
		number = 1 + number % 8
	var folder := "res://assets/music/procedural/" + faction + "/" + type + "/"
	var stream_path := folder + piece_char + str(number) + ".ogg"
	var node = AudioStreamPlayer.new()
	var stream = load(stream_path)
	node.bus = "music"
	node.stream = stream
	return node

func load_nodes_from_fen(fen: String) -> Array:
	reset_arrs()
	#print(fen)
	var out_nodes = [[], [], [], [], []] # intro, p1_a, p1_b, p2_a, p2_b
	var faction_int := -1
	for letter in fen:
		var piece_type: String = letter.to_lower()
		var is_piece := piece_type in cst.piece_lookup
		if letter in cst.fen_faction_lookup:
			faction_int = cst.fen_faction_lookup.find(letter)
		elif is_piece:
			var colour: int = 0 if piece_type == letter else 1
			var p_pieces = p1_pieces if colour == 0 else p2_pieces
			var j := 0
			var n := 1 + p_pieces.count(piece_type)
			var faction_name = get_faction(faction_int, colour)
			for loop_type in ["intro", "a", "b"]:
				if loop_type == "intro" and colour == 0:
					var node := get_stem(faction_name, loop_type, piece_type, n)
					var current_arr: Array = out_nodes[0]
					current_arr.push_back(node)
					add_child(node)
				elif loop_type == "a" or loop_type == "b":
					var node := get_stem(faction_name, loop_type, piece_type, n)
					var current_arr: Array = out_nodes[1 + j + colour * 2]
					current_arr.push_back(node)
					add_child(node)
					j += 1
			p_pieces.push_back(piece_type)
			faction_int = -1
	return out_nodes

func init(fen: String) -> void:
	n_plays = 0
	initial_fen = fen
	var result = load_nodes_from_fen(fen)
	intro_nodes = result[0]
	p1_a_nodes = result[1]
	p1_b_nodes = result[2]
	p2_a_nodes = result[3]
	p2_b_nodes = result[4]
	current_nodes = intro_nodes

func match_loop_n_to_arr(loop_n: int) -> Array:
	if (loop_n - 1) % 4 == 0:
		return p1_a_nodes
	elif (loop_n - 1) % 4 == 1:
		return p2_a_nodes
	elif (loop_n - 1) % 4 == 2:
		return p1_b_nodes
	else:
		return p2_b_nodes

func lose_piece(colour: int, piece_char: String) -> void:
	# delete piece from p_arr, fade with delete tween,
	
	var p_pieces = p1_pieces if colour == 0 else p2_pieces
	var p_audio = match_loop_n_to_arr(n_plays)
	var node_idx = p_pieces.rfind(piece_char)
	print("Taking piece " + piece_char + " at idx " + str(node_idx))
	if node_idx == -1: # this triggers in minigames for some reason
		return
	var node = p_audio[node_idx]
	var tw1 := get_tree().create_tween()
	tw1.tween_property(node, "volume_db", zero_vol_db, FADE_TIME).set_trans(Tween.TRANS_EXPO)
	tw1.tween_callback(node.queue_free)
	p_pieces.pop_at(node_idx)
	p_audio.pop_at(node_idx)

func play() -> void:
	for node in current_nodes:
		node.stop()
	if n_plays >= 1:
		current_nodes = match_loop_n_to_arr(n_plays)
	
	for node in current_nodes:
		node.set_volume_db(0)
		node.play(0.0)
	await current_nodes[-1].finished
	n_plays += 1
	print("N loops of proc music: " + str(n_plays))
	finished.emit()

func stop() -> void:
	for node in current_nodes:
		node.stop()

func set_volume_db(vol_db: float) -> void:
	for node in current_nodes:
		node.volume_db = vol_db
