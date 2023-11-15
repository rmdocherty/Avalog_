extends "res://scenes/pieces/graphics/PlayerCircle.gd"

var dragging := true
var line_1 = drawing.create_line_points(Vector2(-1.1, 0), Vector2(1.1, 0), 0.15, false, stg.draw_iso)
var line_2 = drawing.create_line_points(Vector2(0, -1.1), Vector2(0, 1.1), 0.15, false, stg.draw_iso)

func _draw():
	#position = Vector2(50, 50)
	var _outer_colors = PackedColorArray([default_edge])
	var inner_colors = PackedColorArray([default_colour])
	var inner_inverse = inner_points.duplicate()
	inner_inverse.reverse()
	draw_polygon(outer_points + inner_inverse, inner_colors)
	draw_polygon(line_1, inner_colors)
	draw_polygon(line_2, inner_colors)

func change_draw_mode(iso: bool) -> void:
	inner_points = drawing.get_circle_arc_points(Vector2(0,0), inner_radius, angle_from, angle_to, iso)
	outer_points = drawing.get_circle_arc_points(Vector2(0,0), outer_radius, angle_from, angle_to, iso)
	line_1 = drawing.create_line_points(Vector2(-1.1, 0), Vector2(1.1, 0), 0.15, false, iso)
	line_2 = drawing.create_line_points(Vector2(0, -1.1), Vector2(0, 1.1), 0.15, false, iso)
	queue_redraw()
