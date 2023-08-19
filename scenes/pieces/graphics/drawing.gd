extends Node2D

func get_circle_arc_points(center: Vector2, radius: float, angle_from: float, angle_to: float,
	iso: bool=false) -> PackedVector2Array:
	var nb_points := 64
	var points_arc := PackedVector2Array()
	var new_center: Vector2
	if iso:
		new_center = hlp.norm_to_iso(center)

	for i in range(nb_points + 1):
		var angle_point = deg_to_rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
		var game_p: Vector2 = Vector2(cos(angle_point), sin(angle_point)) 
		if iso:
			game_p = hlp.norm_to_iso(game_p)
		else:
			game_p = cst.LOGIC_PIECE_RADIUS * game_p * cst.FLAT_DRAW_SCALE
		points_arc.push_back(new_center + (game_p * radius))
	return points_arc


func create_line_points(start_pos: Vector2, end_pos: Vector2, width: float,
							pointed: bool=true, iso: bool=false) -> PackedVector2Array:
	var points := PackedVector2Array()
	var dir: Vector2 = (end_pos - start_pos).normalized()
	var ortho: Vector2 = dir.orthogonal()
	
	var left := -width * ortho
	var right := width * ortho
	var brhs := start_pos + right
	var blhs := start_pos + left
	var trhs := end_pos + right
	var tlhs := end_pos + left
	var tmhs := end_pos + dir * width
	if iso:
		brhs = hlp.norm_to_iso(brhs)
		blhs = hlp.norm_to_iso(blhs)
		trhs = hlp.norm_to_iso(trhs)
		tlhs = hlp.norm_to_iso(tlhs)
		tmhs = hlp.norm_to_iso(tmhs)
	else:
		brhs *= cst.LOGIC_PIECE_RADIUS * cst.FLAT_DRAW_SCALE
		blhs *= cst.LOGIC_PIECE_RADIUS * cst.FLAT_DRAW_SCALE
		trhs *= cst.LOGIC_PIECE_RADIUS * cst.FLAT_DRAW_SCALE
		tlhs *= cst.LOGIC_PIECE_RADIUS * cst.FLAT_DRAW_SCALE
		tmhs *= cst.LOGIC_PIECE_RADIUS * cst.FLAT_DRAW_SCALE
	
	points.push_back(brhs)
	points.push_back(blhs)
	points.push_back(tlhs)
	if pointed == true:
		points.push_back(tmhs)
	points.push_back(trhs)
	return points
