extends Node2D
class_name GraphicalPiece

var lines: Array[Polygon2D] = []
var current_polygon := [PackedVector2Array(), PackedVector2Array()]
@onready var sprite: AnimatedSprite2D = $Sprite

func mouse_entered_circle() -> void:
	sprite.play('0_passive')
	show_lines()

func show_lines() -> void:
	for l in lines:
		l.show()

func hide_lines() -> void:
	for l in lines:
		l.hide()

func reset_lines() -> void:
	lines = []

func create_single_line(poly: Polygon2D, start_point: Vector2, end_point: Vector2, pointed: bool=true):
	var points = drawing.create_line_points(start_point, end_point, cst.LINE_DRAW_WIDTH, pointed, true) # was 0.2
	poly.polygon = points
	poly.color = $Phantom/PlayerCircle.default_colour
	poly.z_index = 0 # set z index of enemies to be -1?

func append_line(logic_start_pos: Vector2, logic_end_pos: Vector2, pointed: bool=true):
	var poly = Polygon2D.new()
	add_child(poly)
	create_single_line(poly, logic_start_pos, logic_end_pos, pointed)
	poly.apply_scale(cst.BOARD_DRAW_SCALE)
	poly.hide()
	lines.push_back(poly)

func add_points_to_polygon(inner_point: Vector2, outer_point: Vector2) -> void:
	if inner_point != Vector2(0, 0):
		current_polygon[0].push_back(hlp.norm_to_iso(inner_point))
	current_polygon[1].push_back(hlp.norm_to_iso(outer_point))

func finish_polygon() -> void:
	var poly = Polygon2D.new()
	add_child(poly)
	current_polygon[1].reverse()
	poly.polygon = current_polygon[0] + current_polygon[1]
	poly.hide()
	poly.color = $Phantom/PlayerCircle.default_colour
	poly.z_index = 0
	poly.apply_scale(cst.BOARD_DRAW_SCALE)
	lines.push_back(poly)
	current_polygon = [PackedVector2Array(), PackedVector2Array()]

func update_lines_from_fragment(mv_type: cst.mv_type, draw_type: cst.draw_type, start: Vector2, end: Vector2) -> void:
	var moves: bool = start.length() < end.length()
	var no_attack: bool = (mv_type == cst.mv_type.RANGED or mv_type == cst.mv_type.NO_ATTACK)
	if draw_type == cst.draw_type.LINE and no_attack and moves:
		# need to normalise raycast_end_pos from logic coords to normalized coords before isoing
		append_line(start / cst.LOGIC_SQ_W, end / cst.LOGIC_SQ_W, false)
	elif draw_type == cst.draw_type.LINE and moves:
		append_line(start / cst.LOGIC_SQ_W, end / cst.LOGIC_SQ_W)
	elif draw_type == cst.draw_type.RADIAL:
		if end == Vector2(0, 0):
			finish_polygon()
		else:
			var delta = (end - start).normalized() * cst.LOGIC_PIECE_RADIUS
			var inner_point = (start) / cst.LOGIC_SQ_W
			var outer_point = (end + delta / 2) / cst.LOGIC_SQ_W
			add_points_to_polygon(inner_point, outer_point)

func flip_sprite() -> void:
	for s in [sprite, $Phantom/PhantomSprite]:
		s.flip_h = true

func change_player_circle(state: String) -> void:
	$Phantom/PlayerCircle.set_colour(state)

func _ready() -> void:
	for s in [sprite, $Phantom/PhantomSprite]:
		s.apply_scale(cst.PIECE_DRAW_SCALE)
	if cst.draw_iso:
		sprite.show()
		$Icon.hide()
	else:
		sprite.hide()
		$Icon.show()
	$Phantom/Hover.polygon = $Phantom/PlayerCircle.inner_points



