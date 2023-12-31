extends Node
var helper: mv_helper = mv_helper.new()

const r_moves: Array[Vector2] = [Vector2(0, 1),  Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0)]
const b_moves: Array[Vector2] = [Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1), Vector2(1, 1)]
const k_moves: Array[Vector2] = r_moves + b_moves

func get_king_moves() -> Array[MoveVector]:
	var mvs := helper.get_line_mvs(k_moves, cst.mv_type.NORMAL)
	var state: Array[MoveVector] = [mvs]
	return state


func get_king_castling_moves() -> MoveVector:
	const vecs: Array[Vector2] = [Vector2(1, 0), Vector2(-1, 0)]
	var mvs := helper.get_line_mvs(vecs, cst.mv_type.NORMAL)
	return mvs


func get_queen_moves() -> Array[MoveVector]:
	var mvs := helper.get_line_mvs(k_moves, cst.mv_type.NORMAL, 12.0)
	var state: Array[MoveVector] = [mvs]
	return state


func get_bishop_moves() -> Array[MoveVector]:
	var mvs := helper.get_line_mvs(b_moves, cst.mv_type.NORMAL, 12.0)
	var state: Array[MoveVector] = [mvs]
	return state


func get_rook_moves() -> Array[MoveVector]:
	var mvs := helper.get_line_mvs(r_moves, cst.mv_type.NORMAL, 12.0)
	var state: Array[MoveVector] = [mvs]
	return state


func get_knight_moves() -> Array[MoveVector]:
	const mag := sqrt(5)
	var mvs := helper.get_circle_mvs(0, mag, 0, 360, cst.mv_type.JUMPING, true, 64)
	var state: Array[MoveVector] = [mvs]
	return state


func get_pawn_moves(dir: float=1, monarch_faction: String="a") -> Array:
	var states: Array
	var state_1: MoveVector
	var state_2 := helper.get_line_mvs([Vector2(0, dir)], cst.mv_type.NO_ATTACK)
	if monarch_faction == "a":
		state_1 =  helper.get_line_mvs([Vector2(0, dir)], cst.mv_type.NO_ATTACK, 2.0) 
	else:
		state_1 = state_2
	states = [[state_1], [state_2]]
	return states


func get_pawn_attacks(dir: float=1) -> Array[Vector2]:
	return [Vector2(1, dir), Vector2(-1, dir)]
