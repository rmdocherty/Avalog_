extends Node
var helper: mv_helper = mv_helper.new()

const r_moves: Array[Vector2] = [Vector2(0, 1),  Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0)]
const b_moves: Array[Vector2] = [Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1), Vector2(1, 1)]
const k_moves: Array[Vector2] = r_moves + b_moves

func get_king_moves() -> Array[MoveVector]:
	var mvs := helper.get_line_mvs(k_moves, cst.mv_type.NORMAL)
	var state: Array[MoveVector] = [mvs]
	return state

func get_queen_moves() -> Array[MoveVector]:
	var line: Array[Vector2] = [Vector2(0, 1),  Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0), Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1), Vector2(1, 1)]
	var line_mv := helper.get_line_mvs(line, cst.mv_type.NORMAL, 4.0)

	var sun_mv := MoveVector.new()
	var sun_from = PackedVector2Array([])
	var sun_to = PackedVector2Array([])
	var sun_delta = PackedVector2Array([])
	for i in range(8):
		var angle_deg = 22.5 * (2 * i + 1)
		var angle_rad = 2 * PI *  (angle_deg / 360)
		var dir = Vector2(cos(angle_rad), sin(angle_rad))
		var from = 2 * dir
		var to = 3 * dir
		sun_from.push_back(from)
		sun_to.push_back(to)
		sun_delta.push_back(to - from)
	sun_mv.set_all(cst.draw_type.LINE, cst.mv_type.JUMPING, sun_to, sun_from, sun_delta)
	var state: Array[MoveVector] = [line_mv, sun_mv]
	return state


func get_bishop_moves() -> Array[MoveVector]:
	var mvs := helper.get_line_mvs(b_moves, cst.mv_type.NORMAL, 12.0)
	var state: Array[MoveVector] = [mvs]
	return state


func get_rook_moves() -> Array[MoveVector]:
	#var mvs := helper.get_line_mvs(r_moves, cst.mv_type.NORMAL, 12.0)
	var mvs := helper.get_square_mvs(0, 3, 0, 360, cst.mv_type.NORMAL, false, 256)
	var state: Array[MoveVector] = [mvs]
	return state


func get_knight_moves() -> Array[MoveVector]:
	var line: Array[Vector2] = [Vector2(1, 0), Vector2(-1, 0), Vector2(0, -1), Vector2(0, 1)]
	var mvs := helper.get_line_mvs(line, cst.mv_type.NO_ATTACK, 1.5)
	var state: Array[MoveVector] = [mvs]
	return state


func get_pawn_moves(dir: float=1, monarch_faction: String="a") -> Array:
	var states: Array
	var state_1: MoveVector
	var state_2 := helper.get_line_mvs([Vector2(-1, dir), Vector2(1, dir)], cst.mv_type.NO_ATTACK)
	if monarch_faction == "a":
		state_1 =  helper.get_line_mvs([Vector2(-1, dir), Vector2(1, dir)], cst.mv_type.NO_ATTACK, 2.0) 
	else:
		state_1 = state_2
	states = [[state_1], [state_2]]
	return states


func get_pawn_attacks(dir: float=1) -> Array[Vector2]:
	return [Vector2(0, dir)]
