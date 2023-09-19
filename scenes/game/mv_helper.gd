extends Node
class_name mv_helper

func get_arr_fill(n_items: int, value):
	var empty := Array([])
	empty.resize(n_items)
	empty.fill(value)
	return empty


func scale_vector_list(vec_list: Array[Vector2], scalar: float) -> Array[Vector2]:
	var N_moves := len(vec_list)
	var scaled: Array[Vector2]= []
	for i in range(N_moves):
		scaled.push_back(vec_list[i] * scalar)
	return scaled


func get_line_mvs(lines: Array[Vector2], type: cst.mv_type, scale: float=1.0) -> MoveVector:
	# Get 'Move Vector' from list of lines
	if scale != 1.0:
		lines = scale_vector_list(lines, scale)

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
					mv_type: int=cst.mv_type.JUMPING, delta_inner: bool=false, n_incs: int=32) -> MoveVector:
	# Get circular move vector spanning from inner mag to outer mag and between given angles.
	if delta_inner:
		inner_mag = outer_mag - 0.2 * cst.LOGIC_PIECE_RADIUS / cst.LOGIC_SQ_W
	var from := PackedVector2Array([])
	var to := PackedVector2Array([])
	var dirs := PackedVector2Array([])
	var offset_rad: float = 2 * PI * (angle_from / 360)
	var resolution: int = int( n_incs * ((angle_to - angle_from) / 360 ))

	for i in range(resolution):
		var angle_rad = 2 * PI * (i / float(n_incs))
		var direction = Vector2(cos(offset_rad + angle_rad), sin(offset_rad + angle_rad))
		var inner_point = inner_mag * direction
		var outer_point = outer_mag * direction
		from.append(inner_point)
		to.append(outer_point)
		dirs.append((outer_point - inner_point))

	var move_vector: MoveVector = MoveVector.new()
	move_vector.set_all(cst.draw_type.RADIAL, mv_type, to, from, dirs)
	return move_vector
