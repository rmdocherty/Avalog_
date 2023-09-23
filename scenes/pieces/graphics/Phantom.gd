extends Area2D


var start_click_pos: Vector2
var dragging := false
var logic_pos: Vector2

@onready var graphics: GraphicalPiece = get_parent()
@onready var piece: Piece = get_parent().get_parent()
@onready var gfx_game_manager = get_parent().get_parent().get_parent()

func _input_event(_viewport, event: InputEvent, _shape_idx) -> void:
	var turn_colour: cst.colour = ((piece.turn_number + 1) % 2) as cst.colour
	var turn_matches: bool = (turn_colour == piece.colour)
	var your_piece: bool = (turn_colour == stg.player_colour) or stg.network == cst.network_types.LOCAL
	
	if Input.is_action_just_pressed("click") and turn_matches and your_piece:
		start_click_pos = get_global_mouse_position()
		gfx_game_manager.selected_piece = piece
		print("click start")
		$PhantomSprite.show()
	elif Input.is_action_just_pressed("click"):
		graphics.invalid_input.emit()

	if event.is_action_pressed("click") and turn_matches and your_piece:
		dragging = true

	if event.is_action_released("click") and turn_matches:
		pass

func mouse_exited_circle() -> void:
	if !dragging:
		graphics.sprite.play("0_passive")
		graphics.sprite.stop()
		graphics.hide_lines()

func _process(_delta: float) -> void:
	if dragging:
		var mouse_delta_screen := (get_global_mouse_position() - start_click_pos)
		var mouse_delta_logic: Vector2

		if stg.draw_iso:
			mouse_delta_logic = hlp.iso_to_logic(mouse_delta_screen / cst.BOARD_DRAW_SCALE)
		else:
			mouse_delta_logic = mouse_delta_screen
	
		var projections: Array[float] = []
		for i in range(len(piece.flat_starts)):
			var is_line := (piece.flat_draws[i] == cst.draw_type.LINE)
			var dir := piece.flat_ends[i] - piece.flat_starts[i]
			var a := dir.normalized()
			var b := mouse_delta_logic.normalized()
			var dist_sim := 0.0
			
			if piece.mixed_move_types and is_line:
				dist_sim = 0.08
			elif piece.mixed_move_types:
				dist_sim = 1/(mouse_delta_logic - piece.flat_ends[i]).length()
			projections.push_back(a.dot(b) + dist_sim)

		var largest_proj: float = projections.max()
		var loc := projections.find(largest_proj, 0)

		var most_similar_delta := piece.flat_ends[loc] - piece.flat_starts[loc]
		var slide = mouse_delta_logic.length() * most_similar_delta.normalized()
		logic_pos = piece.pos_from_slide(slide, piece.flat_ends[loc], piece.flat_starts[loc], mouse_delta_logic)
		
		if stg.draw_iso:
			position = hlp.logic_to_iso(cst.BOARD_DRAW_SCALE * logic_pos)
		else:
			position = logic_pos
