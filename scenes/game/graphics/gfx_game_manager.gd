extends Node2D

const LogicGameManager = preload("res://scenes/game/game_manager.tscn")
var game_manager := LogicGameManager.instantiate()

const colours: Array[Color] = [Color("#d9a066"), Color("#8f563b")]

const start_x := -4
const start_y := -4

var gfx_offset := cst.FLAT_DRAW_SCALE * cst.LOGIC_SQ_W * Vector2(start_x, start_y)

var player_monarch_factions: Array[cst.factions] = [cst.factions.ALBION, cst.factions.ALBION]

var change_player_each_turn: bool = true
var is_minigame: bool = false

var all_pieces: Array[Piece] = []
var selected_piece: Piece
var taken_pieces: Array[String] = []

@onready var board := $board

# ======================== FEN LOGIC =================
func invert_str(s: String) -> String:
	# this needs to work for afens
	var out: String = ""
	var str_idx := s.length() - 1
	while str_idx >= 0:
		var possible_faction := s[str_idx - 1].to_lower()
		var c = s[str_idx]
		if c == "Q":
			c = "K"
		elif c == "q":
			c = "k"
		elif c == "K":
			c = "Q"
		elif c == "k":
			c = "q"
			
		if possible_faction in cst.fen_faction_lookup:
			out += possible_faction
			out += c
			str_idx -= 2
		elif c not in cst.fen_faction_lookup:
			out += c
			str_idx -= 1
	return out

func assemble_fen(other_half_fen: String) -> String:
	var FEN: String = ""
	var your_fen: String = stg.half_FEN
	var opponent_fen: String = other_half_fen
	if stg.player_colour == cst.colour.WHITE:
		your_fen = stg.half_FEN.to_upper()
		FEN = opponent_fen + "8/8/8/8" + invert_str(your_fen)
	else:
		opponent_fen = other_half_fen.to_upper()
		FEN = your_fen + "8/8/8/8" + invert_str(opponent_fen)
	print(FEN)
	return FEN

func fen_recieved(other_half_fen: String) -> void:
	var fen = assemble_fen(other_half_fen)
	if stg.player_colour == cst.colour.BLACK:
		$Camera2D.flip_camera()
		var o = stg.replace_palettes
		var new_palettes: Array[int] = [o[1], o[0], o[3], o[2]]
		stg.replace_palettes = new_palettes
	init(fen)

func find_factions_of_monarchs(fen_str: String) -> Array[cst.factions]:
	"""Loop through FEN to get faction of king per player, i.e if in draft mode and king has a
	faction modifier prepended else just use player faction."""
	var monarch_factions: Array[cst.factions] = [cst.factions.ALBION, cst.factions.ALBION]
	var idx: int = 0
	for letter in fen_str:
		if letter.to_lower() == "k":
			var colour: cst.colour
			var piece_type: String = letter.to_lower()

			if (letter == piece_type):
				colour = cst.colour.BLACK
			else:
				colour = cst.colour.WHITE

			var faction_int: int
			if fen_str[idx - 1] in cst.fen_faction_lookup:
				faction_int = cst.fen_faction_lookup.find(fen_str[idx - 1], 0)
			else:
				faction_int = stg.chosen_factions[colour]
			monarch_factions[colour] = faction_int as cst.factions
		idx += 1
	return monarch_factions

func add_pieces_from_fen(fen_str: String) -> Array[Piece]:
	"""Loop through FEN string, initialising new pieces at correct position w/ correct colour."""
	player_monarch_factions = find_factions_of_monarchs(fen_str)
	
	var pieces: Array[Piece] = []
	var x_idx: int = start_x
	var y_idx: int = start_y
	var faction_int: int = -1
	var i := 0
	for letter in fen_str:
		var p0 := Vector2((x_idx + 0.5) * cst.LOGIC_SQ_W, (y_idx + 0.5) * cst.LOGIC_SQ_W)
		if letter == '/':
			y_idx += 1
			x_idx = start_x
		elif letter.is_valid_int():
			x_idx += int(letter)
		elif letter in cst.fen_faction_lookup:
			faction_int = cst.fen_faction_lookup.find(letter, 0)
		else:
			var piece: Piece = add_piece(letter, p0, i, faction_int)
			piece.taken.connect(on_piece_taken)
			# connect taken callback here
			i += 1
			pieces.push_back(piece)
			faction_int = -1
			x_idx += 1
	return pieces

func add_piece(piece_letter: String, pos: Vector2, piece_n: int, faction_int: int) -> Piece:
	"""Query the lookup and get a piece, initialise it then add as a child."""
	var colour: cst.colour
	var piece_type: String = piece_letter.to_lower()
	if (piece_letter == piece_type):
		colour = cst.colour.BLACK
	else:
		colour = cst.colour.WHITE
	
	var faction: String
	if faction_int == -1:
		faction_int = stg.chosen_factions[colour]
	faction = cst.faction_lookup[faction_int]
	# Need to add a check for monarch faction to this function and find it before looping through fen
	var monarch_faction_char: String = cst.faction_lookup[player_monarch_factions[colour]]
	var temp_piece = lkp.add_piece(faction, piece_type, colour, monarch_faction_char)
	add_child(temp_piece)
	temp_piece.init(pos, colour, piece_n)
	all_pieces.push_back(temp_piece)
	return temp_piece

func apply_morgana_aura(piece_list: Array[Piece], _monarch_factions: Array[cst.factions]) -> Array[Piece]:
	var zombie_positions := [cst.LOGIC_SQ_W * Vector2(0, 1.5), cst.LOGIC_SQ_W * Vector2(0, -1.5)]
	for i in range(2):
		var player_faction := player_monarch_factions[i]
		if player_faction == cst.factions.MORGANA:
			var colour := i as cst.colour
			var temp_piece = lkp.add_piece("m", "p", colour, "m")
			add_child(temp_piece)
			temp_piece.init(zombie_positions[i], colour, len(piece_list))
			piece_list.push_back(temp_piece)
	return piece_list

# ======================== GAME LOGIC =================
func init(fen: String, track: int=1) -> void:
	Music.procedural.init(fen)
	remove_all()
	$GUILayer/win_menu.hide_winner()
	$GUILayer.show_bar()

	Music.switch_tracks(track)

	all_pieces = add_pieces_from_fen(fen)
	all_pieces = apply_morgana_aura(all_pieces, player_monarch_factions)

	game_manager.add_pieces_from_nodes(all_pieces)
	game_manager.init(player_monarch_factions)
	# short delay here so all nodes can load before we find moves
	$InitialTimer.start()

func custom_init(map: int, FEN: String) -> void:
	$GUILayer.hide()
	$board.play(str(map))
	init(FEN, Music.tracks.MENU)

func start_game() -> void:
	take_turn(false)
	$GUILayer.clock_start_after_move_finished(game_manager.current_turn_colour)

func y_sort(a, b):
	# need to use logical position to make sure it's updated properly
	var a_pos := hlp.logic_to_iso(a.logic.global_position)[1]
	var b_pos := hlp.logic_to_iso(b.logic.global_position)[1]
	return a_pos < b_pos

func take_turn_timer_trigger() -> void:
	take_turn(change_player_each_turn)


func take_turn(change_player: bool=true) -> void:
	"""Update the logical game manager (to find all piece's moves), loop through all pieces and 
	update their graphics (colours, lines, z-index)."""
	var colour = 1 - game_manager.current_turn_colour
	print("Turn number is: " + str(game_manager.turn_number) + ", colour is: " + str(1 - colour))
	for letter in taken_pieces:
		if is_minigame == false:
			Music.procedural.lose_piece(colour, letter)
	taken_pieces = []

	var turn_n: int = game_manager.take_turn(change_player)
	$GUILayer.clock_start_after_move_finished(game_manager.current_turn_colour)
	var z_count: int = 0
	all_pieces.sort_custom(y_sort)
	for p in all_pieces: 
		var logic: LogicPiece = p.logic
		# Update positions (i.e for deletions/castling)
		p.show()
		p.set_graphic_pos(logic.position, stg.draw_iso)
		p.change_turn(turn_n)
		#p.update_lines(logic.nested_valid_moves)
		check_win(p)
		
		# Display current turn pieces and further down pieces on top 
		var z_inc: int = 0
		if p.colour == game_manager.current_turn_colour:
			z_inc = 50
		p.z_index = z_count + z_inc
		z_count += 1

func gfx_update() -> void:
	for p in all_pieces:
		var old_scale := p.graphics.sprite.scale
		var new_scale := stg.PIECE_DRAW_SCALE / old_scale 
		p.graphics.sprite.apply_scale(new_scale) #stg.PIECE_DRAW_SCALE
		p.graphics.get_node("Phantom/PhantomSprite").apply_scale(new_scale) #stg.PIECE_DRAW_SCALE
		p.graphics.classic_icons_toggle(stg.classic_icons)
		p.set_graphic_pos(p.logic.position, stg.draw_iso)
		p.graphics.update_iso(stg.draw_iso)
		p.update_lines(p.logic.nested_valid_moves)


func check_win(piece: Piece) -> void:
	var logic: LogicPiece = piece.logic
	if piece.piece_char == "k" && logic.state == logic.states.DEAD:
		var win_colour = 1 - piece.colour as cst.colour
		await get_tree().create_timer(0.75).timeout
		win(win_colour)

func win(win_colour: cst.colour) -> void:
	$GUILayer.hide_bar(true)
	$GUILayer/win_menu.show_winner(win_colour)

func remove_all() -> void:
	game_manager.delete_all_pieces()
	for p in all_pieces:
		p.set_graphic_pos(p.logic.position)
	all_pieces = []

# ======================== MOVE BUTTONS =================
func reset_piece_drag() -> void:
	selected_piece.reset_drag_hide_phantom()
	hide_buttons()

func _unhandled_input(_event: InputEvent) -> void:
	"""Fall-through for mouse events: i.e if click ends show the buttons."""
	if not selected_piece:
		return
	var gfx: GraphicalPiece = selected_piece.get_node("GraphicalPiece")
	var phantom = gfx.get_node("Phantom")
	if Input.is_action_just_released("click") and phantom.dragging:
		phantom.dragging = false
		gfx.hide_lines()
		print("released")
		show_buttons()
	elif Input.is_action_just_pressed("click"):
		if phantom.dragging == false:
			gfx.hide_lines()
			reset_piece_drag()

func show_buttons() -> void:
	var global_pos = selected_piece.get_node("GraphicalPiece/Phantom").global_position
	var i := 0
	var y_pos := [-28, -8]
	for btn in [$ConfirmMove, $RejectMove]:
		var x := 16
		if $Camera2D.flip_vec[0] == -1:
			btn.flip_h = true
			x = -32
		else:
			btn.flip_h = false
		btn.global_position = global_pos + Vector2(x, y_pos[i])
		btn.show()
		i += 1

func hide_buttons() -> void:
	$ConfirmMove.hide()
	$RejectMove.hide()

func confirm_move() -> void:
	var move_dist: Vector2 = selected_piece.graphics.get_node("Phantom").logic_pos
	move_piece_dist(selected_piece, move_dist, true)


func send_move(piece: Piece, move_dist: Vector2) -> void:
	var clock: Node = $GUILayer/Clock1
	var t_min: int = clock.time_mins
	var t_sec: int = clock.time_seconds

	var packet: Dictionary = {"type":"move", "piece_n":piece.piece_n, "pos":move_dist, "t_min": t_min, "t_sec": t_sec}
	print(str(steam.STEAM_ID) + "  " + str(stg.OTHER_PLAYER_ID))
	$P2P._send_P2P_packet(stg.OTHER_PLAYER_ID, packet)

func recieve_move(piece_n: int, move_dist: Vector2, t_min: int, t_sec: int) -> void:
	var piece: Piece
	for p in all_pieces:
		if p.piece_n == piece_n:
			piece = p
			selected_piece = p
	move_piece_dist(piece, move_dist)
	# Update opponent's clock with their local time
	var clock: Node = $GUILayer/Clock2
	clock.time_mins = t_min
	clock.time_seconds = t_sec
	

func move_piece_dist(piece: Piece, move_dist: Vector2, send:bool=false) -> void:
	game_manager.move_piece(piece, move_dist)
	$GUILayer.clock_stop_after_move_confirmed(game_manager.current_turn_colour)
	if $P2P.connected and send:
		send_move(piece, move_dist)
	reset_piece_drag()
	hide_buttons()

func after_piece_finished_moving() -> void:
	# we need a short delay here s.t the physics can update after piece moved
	$Camera2D.movement_zoom_out()
	$TakeTurnTimer.start()

func on_piece_taken(letter: String) -> void:
	taken_pieces.append(letter)

# ======================== DRAWING =================
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
	if stg.draw_iso == false:
		draw_flat_board(8, 8)

func show_board(is_flat: bool) -> void:
	stg.draw_iso = not is_flat
	if not is_flat:
		$board.show()
	else:
		$board.hide()
	gfx_update()
	queue_redraw()

# ======================== CONNECTION ========================
func back() -> void:
	if $P2P.connected:
		$P2P._close_connection()
	
func request_remtach() -> void:
	var packet = {"type":"rematch_request"}
	$P2P._send_P2P_packet(stg.OTHER_PLAYER_ID, packet)
	

func accept_rematch() -> void:
	stg.player_colour = 1 - stg.player_colour as cst.colour
	var packet = {"type":"rematch_accept"}
	$P2P._send_P2P_packet(stg.OTHER_PLAYER_ID, packet)
	fen_recieved(stg.opponent_half_FEN)
	
func warning_recived(warning_text: String) -> void:
	var warning: Control = load("res://scenes/menus/in_game/warning_modal.tscn").instantiate()
	warning.init(warning_text, true)
	$GUILayer.add_child(warning)

# ======================== PROCCESSES =================
func _ready() -> void:
	game_manager.connect("promotion", $Promote.play)
	$P2P.connect("warning", warning_recived)
	board.apply_scale(cst.BOARD_DRAW_SCALE)
	board.play(str(stg.chosen_map))
	if stg.draw_iso == true:
		board.show()
		pass
	else:
		board.hide()

func _init():
	add_child(game_manager)


