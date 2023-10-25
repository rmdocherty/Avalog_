extends Node

var helper: mv_helper = mv_helper.new()

const r_moves: Array[Vector2] = [Vector2(0, 1),  Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0)]
const b_moves: Array[Vector2] = [Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1), Vector2(1, 1)]
const k_moves: Array[Vector2] = r_moves + b_moves

func get_king_moves() -> Array[MoveVector]:
	var mvs := helper.get_line_mvs(k_moves, cst.mv_type.NORMAL)
	var state: Array[MoveVector] = [mvs]
	return state

func get_queen_moves() -> Array:
	var line: Array[Vector2] = [Vector2(1.000, 0.000), Vector2(0.309, 0.951), Vector2(-0.809, 0.588), Vector2(-0.809, -0.588), Vector2(0.309, -0.951)]
	var state_1 = [helper.get_line_mvs(line, cst.mv_type.NORMAL, 12)]
	var state_2 = [helper.get_circle_mvs(0, sqrt(1), 0, 240, cst.mv_type.JUMPING, true, 128), 
				   helper.get_circle_mvs(0, sqrt(2), 0, 240, cst.mv_type.JUMPING, true, 128),
				   helper.get_circle_mvs(0, sqrt(6), 180, 180 + 240, cst.mv_type.JUMPING, true, 128),
				   helper.get_circle_mvs(0, sqrt(8.5), 180, 180 + 240, cst.mv_type.JUMPING, true, 128),
				]
	var state: Array = [state_1, state_2]
	return state


func get_bishop_moves() -> Array[MoveVector]:
	var mvs := helper.get_line_mvs(r_moves, cst.mv_type.NORMAL, 12.0)
	var state: Array[MoveVector] = [mvs]
	return state


func get_rook_moves() -> Array[MoveVector]:
	var mvs := helper.get_line_mvs(k_moves, cst.mv_type.NO_ATTACK, 2.0)
	var state: Array[MoveVector] = [mvs]
	return state


func get_knight_moves() -> Array:
	const mag := sqrt(3)
	var state_1 := helper.get_circle_mvs(0, mag, 0, 360, cst.mv_type.JUMPING, true, 64)
	var state_2 := helper.get_line_mvs(r_moves, cst.mv_type.NO_ATTACK, 1.5)
	var states: Array = [[state_1], [state_2]]
	return states


func get_pawn_moves(dir: float=1, monarch_faction: String="a") -> Array:
	var states: Array
	var state_1 := helper.get_line_mvs([Vector2(0, dir)], cst.mv_type.NORMAL)
	var state_2 := helper.get_line_mvs([Vector2(-1, dir), Vector2(1, dir)], cst.mv_type.NORMAL)
	states = [[state_1], [state_2]]
	return states
