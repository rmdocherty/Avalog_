extends Node2D

const inner_radius := ((cst.LOGIC_PIECE_RADIUS * cst.BOARD_DRAW_SCALE[0]) / cst.LOGIC_SQ_W)
const outer_radius := inner_radius + 0.2
const angle_from := 0
const angle_to := 360

var inner_points: PackedVector2Array = drawing.get_circle_arc_points(Vector2(0,0), inner_radius, angle_from, angle_to, stg.draw_iso)
var outer_points: PackedVector2Array = drawing.get_circle_arc_points(Vector2(0,0), outer_radius, angle_from, angle_to, stg.draw_iso)

var red := Color(0.96, 0.29, 0.29, 0.8)
var blue := Color(0.29, 0.56, 0.96, 0.8)
var yellow := Color(0.92, 0.8, 0.2, 0.8)
var grey := Color("#dcdfe3")

var default_colour: Color = blue
var default_edge: Color = grey
var current_state: String = "active"

func set_colour(state: String) -> void:
	current_state = state
	if state == "active":
		default_colour = blue
	else:
		default_colour = red
	queue_redraw()

func make_yellow() -> void:
	default_colour = yellow
	queue_redraw()

func reset_colour() -> void:
	default_colour = blue
	queue_redraw()

func _draw() -> void:
	draw_colored_polygon(outer_points, default_edge)
	draw_colored_polygon(inner_points, default_colour)

