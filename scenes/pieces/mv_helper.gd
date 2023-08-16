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
	
	var mv_types := PackedInt32Array(get_arr_fill(n_moves, type))
	var draw := PackedInt32Array(get_arr_fill(n_moves, cst.draw_type.LINE))
	
	var move_vector: MoveVector = MoveVector.new()
	move_vector.set_all(draw, mv_types, to, from, dirs)
	return move_vector
