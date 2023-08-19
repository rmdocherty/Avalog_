extends Node
class_name mv_helper

func get_arr_fill(n_items: int, value) -> Array:
	var empty := Array([])
	empty.resize(n_items)
	empty.fill(value)
	return empty

func get_line_mvs(lines: Array[Vector2], type: cst.mv_type) -> MoveVector:
	# get move vectors from list of lines
	var n_moves: int = len(lines)
	var to := PackedVector2Array(lines)
	var from := PackedVector2Array(get_arr_fill(n_moves, Vector2(0, 0)))
	var dirs := PackedVector2Array([])
	for i in range(len(to)):
		dirs.append((to[i] - from[i]))

	var move_vector: MoveVector = MoveVector.new()
	move_vector.set_all(cst.draw_type.LINE, type, to, from, dirs)
	return move_vector

func get_circle_mvs(inner_mag: float, outer_mag: float, angle_from: float, angle_to: float, 
					mv_type: int=cst.JUMPING, delta_inner: bool=false, n_incs: int=32):
	# add ability to change res and increase for pieces w/ larger magnitude, decrease for smaller
	if delta_inner:
		inner_mag = outer_mag - 0.2 * cst.LOGIC_PIECE_RADIUS / cst.LOGIC_SQ_W
	var from_circ = PackedVector2Array([])
	var to_circ = PackedVector2Array([])
	var dir_cir = PackedVector2Array([])
	var offset_rad = 2 * PI * (angle_from / 360)
	var resolution: int = int( n_incs * ((angle_to - angle_from) / 360 ))

	for i in range(resolution):
		var angle_rad = 2 * PI * (i / float(n_incs))
		var direction = Vector2(cos(offset_rad + angle_rad), sin(offset_rad + angle_rad))
		var inner_point = inner_mag * direction
		var outer_point = outer_mag * direction
		from_circ.append(inner_point)
		to_circ.append(outer_point)
		dir_cir.append((outer_point - inner_point))
	#var circle_move_vector = [cst.RADIAL, mv_type, from_circ, to_circ]
	var circle_move_vector = {"draw_type": cst.RADIAL, "mv_type": mv_type, "from_arr": from_circ, "to_arr": to_circ, "delta_arr": dir_cir, "ranged_dist": 0}
	return circle_move_vector
