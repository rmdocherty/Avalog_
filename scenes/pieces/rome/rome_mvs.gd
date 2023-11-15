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
	var line: Array[Vector2] = [Vector2(0, 1),  Vector2(0, -1), Vector2(1, 0), Vector2(-1, 0)]
	var mvs := helper.get_line_mvs(line, cst.mv_type.NORMAL, 3)
	var state: Array[MoveVector] = [mvs]
	for mag in [sqrt(2), sqrt(5)]:
		var circle = helper.get_circle_mvs(0, mag, 0, 360, cst.mv_type.JUMPING, true)
		state.append(circle)
	return state


func get_bishop_moves() -> Array[MoveVector]:
	var state: Array[MoveVector] = []
	for i in range(4):
		var angle = i * 90
		var circle = helper.get_circle_mvs(0.1, sqrt(4.5), angle - 20, angle + 20, cst.mv_type.NORMAL)
		state.push_back(circle)
	return state


func get_knight_moves() -> Array[MoveVector]:
	var line: Array[Vector2] = [Vector2(1, -1), Vector2(-1, 1), Vector2(-1, -1), Vector2(1, 1)]
	var mvs := helper.get_line_mvs(line, cst.mv_type.NORMAL, 3)
	var state: Array[MoveVector] = [mvs]
	return state


func get_rook_moves() -> Array[MoveVector]:
	var mvs := helper.get_circle_mvs(0, 3, 0, 360, cst.mv_type.NORMAL, false, 256)
	var state: Array[MoveVector] = [mvs]
	return state


func get_pawn_moves(dir: float=1, monarch_faction: String="a") -> Array:
	var inner := dir * 0.1
	var forward := dir * 0.75

	var states: Array
	var state_1: MoveVector
	var state_2 := helper.get_circle_mvs(inner, forward, 45, 135, cst.mv_type.NORMAL, false, 32)
	if monarch_faction == "a":
		#state_1 =  helper.get_line_mvs([Vector2(0, dir)], cst.mv_type.NO_ATTACK, 2.0)
		state_1 = helper.get_circle_mvs(inner, 2 * forward, 45, 135, cst.mv_type.NORMAL, false, 32)
	else:
		state_1 = state_2
	states = [[state_1], [state_2]]
	return states


