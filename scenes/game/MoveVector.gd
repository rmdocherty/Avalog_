extends Node
class_name MoveVector

var draw_type: int = cst.draw_type.LINE
var move_type: int = cst.mv_type.NORMAL
var to_arr: PackedVector2Array = []
var from_arr: PackedVector2Array = []
var delta_arr: PackedVector2Array = []
var N: int = 0

func set_all(draw: int, move: int, to: PackedVector2Array,
			from: PackedVector2Array, delta: PackedVector2Array) -> void:
	draw_type = draw
	move_type = move
	to_arr = to
	from_arr = from
	delta_arr = delta
	N = len(to_arr)
