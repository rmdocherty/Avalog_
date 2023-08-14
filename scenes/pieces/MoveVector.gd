extends Node
class_name MoveVector

var draw_type: PackedInt32Array = []
var move_type: PackedInt32Array = []
var to_arr: PackedVector2Array = []
var from_arr: PackedVector2Array = []
var delta_arr: PackedVector2Array = []

func set_all(draw: PackedInt32Array, move: PackedInt32Array, to: PackedVector2Array,
from: PackedVector2Array, delta: PackedVector2Array) -> void:
	draw_type = draw
	move_type = move
	to_arr = to
	from_arr = from
	delta_arr = delta
