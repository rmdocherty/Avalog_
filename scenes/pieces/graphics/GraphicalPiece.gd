extends Node2D
class_name GraphicalPiece

signal invalid_input

var rng = RandomNumberGenerator.new()

var lines: Array[Polygon2D] = []
var current_polygon := [PackedVector2Array(), PackedVector2Array()]
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var circle: Node2D = $Phantom/PlayerCircle
@onready var piece: Piece = get_parent()

var passive_anim: String = "0_passive"
var attack_anim: String = "0_attack"

func mouse_entered_circle() -> void:
	# maybe change this later, or remove previous call
	piece.update_lines(piece.logic.nested_valid_moves)
	if piece.moving == false:
		sprite.play(passive_anim)
		show_lines()

# ======================= LINES =======================
func show_lines() -> void:
	for l in lines:
		l.show()

func hide_lines() -> void:
	for l in lines:
		l.hide()

func delete_lines() -> void:
	hide_lines()
	reset_lines()

func reset_lines() -> void:
	lines = []

func create_single_line(poly: Polygon2D, start_point: Vector2, end_point: Vector2, pointed: bool=true):
	var points = drawing.create_line_points(start_point, end_point, stg.LINE_DRAW_WIDTH, pointed, stg.draw_iso) # was 0.2
	poly.polygon = points
	poly.color = circle.default_colour
	poly.z_index = 0 # set z index of enemies to be -1?
	var stipple_on: bool = ((circle.current_state != "active") && (circle.current_state != "paused")) && stg.stipple
	if stipple_on:
		poly = add_stipple(poly)

func append_line(logic_start_pos: Vector2, logic_end_pos: Vector2, pointed: bool=true):
	var poly = Polygon2D.new()
	add_child(poly)
	create_single_line(poly, logic_start_pos, logic_end_pos, pointed)
	poly.apply_scale(cst.BOARD_DRAW_SCALE)
	poly.hide()
	lines.push_back(poly)

func add_points_to_polygon(inner_point: Vector2, outer_point: Vector2) -> void:
	if stg.draw_iso:
		inner_point = hlp.norm_to_iso(inner_point)
		outer_point = hlp.norm_to_iso(outer_point)
	else:
		inner_point *= cst.LOGIC_PIECE_RADIUS
		outer_point *= cst.LOGIC_PIECE_RADIUS
	
	if inner_point != Vector2(0, 0):
		current_polygon[0].push_back(inner_point)
	current_polygon[1].push_back(outer_point)

func add_stipple(poly: Polygon2D) -> Polygon2D:
	var texture = NoiseTexture2D.new()
	texture.width = 128
	texture.height = 128
	var noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 0.1
	noise.fractal_type = FastNoiseLite.FRACTAL_NONE
	texture.noise = noise
	texture.normalize = false
	poly.texture = texture
	return poly
	

func finish_polygon() -> void:
	var poly = Polygon2D.new()
	add_child(poly)
	current_polygon[1].reverse()
	poly.polygon = current_polygon[0] + current_polygon[1]
	poly.hide()
	poly.color = circle.default_colour
	var stipple_on: bool = ((circle.current_state != "active") && (circle.current_state != "paused")) && stg.stipple
	if stipple_on:
		poly = add_stipple(poly)
	
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

# ======================= LINES =======================
func flip_sprite() -> void:
	for s in [sprite, $Phantom/PhantomSprite, $Icon]:
		s.flip_h = true

func change_player_circle(state: String) -> void:
	circle.set_colour(state)

func _on_area_entered(area: Area2D):
	# this is called when an area enters this area (i.e when black queen dragged on white pawn, $area=black queen)
	if area.dragging:
		circle.make_yellow()
		area.get_node("PhantomSprite").play(attack_anim)
		sprite.play(passive_anim)

func _on_area_exited(_area: Area2D):
	circle.set_colour(circle.current_state)
	$Phantom/PhantomSprite.play(passive_anim)
	
	
# ======================= ANIMS =======================
func start_idle_timer():
	var random_time = rng.randf_range(4, 36)
	$IdleAnimationTimer.start(random_time)

func idle_anim_timer_trigger():
	var random_num = rng.randi_range(0, 9)
	if random_num >= 6 and stg.ANIM_ON:
		for i in range(2):
			await idle_anim_play()
		sprite.stop()
	start_idle_timer()

func idle_anim_play():
	sprite.play(passive_anim)
	await sprite.animation_looped

# ======================= ISO STUFF =======================
func update_iso(iso: bool) -> void:
	if iso:
		sprite.show()
		$Icon.hide()
	else:
		sprite.hide()
		$Icon.show()
	circle.change_draw_mode(iso)
	$Phantom/Hover.polygon = circle.inner_points
	if piece.ranged:
		$Phantom/RangedCircle.polygon = circle.inner_points
		$Phantom/RangedCircle.change_draw_mode(iso)

func classic_icons_toggle(state: bool) -> void:
	if state == true and stg.mode == cst.modes.CLASSIC:
		var colour_s: String = str(piece.colour)
		$Icon.play(colour_s)
	else:
		$Icon.play("default")

# ======================= PROCESSES =======================
func _ready() -> void:
	for s in [sprite, $Phantom/PhantomSprite]:
		s.scale = (stg.PIECE_DRAW_SCALE)
	update_iso(stg.draw_iso)
	$Phantom/Hover.polygon = circle.inner_points
	start_idle_timer()



