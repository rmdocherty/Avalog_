extends Node2D


var minigameClass = preload("res://scenes/game/graphics/gfx_game_manager.tscn")
var minigame_1
var minigame_2

var pageClass = preload("res://scenes/menus/draft/DraftPage.tscn")
var page_1 
var page_2
var pages := []
var minigames := []

var fen_str := ""


var pick_idx := 0
var n_players := 1
const pick_order := [1, 2, 3, 3, 4, 4, 5, 5, 6, 6, 6, 6, 6, 6, 6, 6]
const positions := [3, 4, 2, 5, 1, 6, 0, 7]

var current_player_pieces := ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]


func _ready() -> void:
	minigame_1 = minigameClass.instantiate()
	minigame_2 = minigameClass.instantiate()
	minigame_1.is_minigame = true
	minigame_2.is_minigame = true

	minigames = [minigame_1, minigame_2]
	load_pages(pick_idx)
	$Parent/Player.text = stg.uname_1

func init() -> void:
	load_pages(pick_idx)


func reset_pages() -> void:
	for p in pages:
		remove_child(p)
	pages = []

func get_codex_idxs(idx: int) -> Array[int]:
	var init_codex_idx = pick_order[idx]
	var possible_choices = []
	for i in range(len(cst.faction_lookup)):
		possible_choices.push_back(init_codex_idx + i * 6)
	var choices: Array[int] = []
	var choice
	for i in range(2):
		choice = possible_choices.pick_random()
		choices.push_back(choice)
		possible_choices.erase(choice)
	return choices

func load_pages(idx: int) -> void:
	page_1 = pageClass.instantiate()
	page_2 = pageClass.instantiate()
	pages = [page_1, page_2]
	var idxs := get_codex_idxs(idx)
	var pieceTypeText: String
	for i in range(2):
		var page = pages[i]
		page.debug = false
		var game = minigames[i]
		$Parent.add_child(page)
		pieceTypeText = page.init(game, idxs[i], i)
		page.state = 1
		page.position = Vector2(300 + 570 * i, 0)
		page.target_pos = Vector2(300 + 570 * i, 300)
		page.target_rot = (2 * i - 1) * 0.15 * randf_range(0.6, 1.4)
	$Parent/ChooseYour.text = "Pick a %s" % pieceTypeText

func move_pages(idx: int) -> void:
	pages[idx].target_pos = Vector2(300 + 285, 300)
	pages[idx].target_rot = randf_range(-0.5, 0.5)
	pages[idx].state = 3

	var other = int(abs(1 - idx))
	var dir = (2 * other - 1) 
	pages[other].snap()
	pages[other].target_pos = Vector2(dir * 1400, 900 + 200 * randf_range(-1, 1))
	pages[other].target_rot = dir * randf_range(0.35, 0.45)

	pages[other].state = 4

func insert_piece_into_arr(piece_char: String, idx: int, player_n: int) -> void:
	var insert_idx: int
	if idx > 7:
		insert_idx = pick_idx
	elif idx == 0 and player_n == 2:
		insert_idx = positions[idx] + 1
	elif idx == 1 and player_n == 2:
		insert_idx = positions[idx] - 1
	else:
		insert_idx = positions[idx]
	current_player_pieces[insert_idx] = piece_char

func insert_pieces_into_fen(player_pieces: Array, player_n: int) -> String:
	var temp_str = ""
	if player_n == 1:
		fen_str = "/8/8/8/8/"
		player_pieces.reverse()
		var i := 0
		for p in player_pieces:
			if i == 8:
				temp_str += "/"
				i = 0
			temp_str += p
			i += 1
		fen_str = fen_str + temp_str
	elif player_n == 2:
		var i := 0
		for p in player_pieces:
			if i == 8:
				temp_str += "/"
				i = 0
			temp_str += p
			i += 1
		fen_str = temp_str + fen_str
	return temp_str

func pick_page(idx: int) -> void:
	move_pages(idx)
	var chosen_faction: String = cst.fen_faction_lookup[pages[idx].faction_idx]
	var chosen_piece: String = pages[idx].type_lookup[pick_order[pick_idx] - 1]
	if n_players == 1:
		chosen_piece = chosen_piece.to_upper()
	
	insert_piece_into_arr(chosen_faction + chosen_piece, pick_idx, n_players)
	pick_idx += 1

	if pick_idx == len(pick_order):
		print('a player has finished picking', n_players)
		finish_picking(n_players)
	else:
		load_pages(pick_idx)

func finish_picking(player_n: int) -> void:
	if player_n == 1 and stg.network == cst.network_types.ONLINE:
		var half_fen = insert_pieces_into_fen(current_player_pieces, player_n)
		fen_str = fen_str.to_lower() # half fens in lowercase
		stg.half_FEN = half_fen
		var game_path := "res://scenes/game/graphics/gfx_game_manager.tscn"
		var child: Node = load(game_path).instantiate()
		get_tree().get_root().add_child(child)
		get_tree().get_root().remove_child(self)
	elif player_n == 1 and stg.network == cst.network_types.LOCAL:
		insert_pieces_into_fen(current_player_pieces, n_players)
		current_player_pieces = ["", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
		n_players += 1
		pick_idx = 0

		$Parent/Player.text = stg.uname_2
		load_pages(pick_idx)
	elif player_n == 2 and stg.network == cst.network_types.LOCAL:
		insert_pieces_into_fen(current_player_pieces, n_players)
		var game_manager = load("res://scenes/game/graphics/gfx_game_manager.tscn").instantiate()
		get_tree().get_root().add_child(game_manager)
		print(fen_str)
		game_manager.init(fen_str)
		queue_free()
