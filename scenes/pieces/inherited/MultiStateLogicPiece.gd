extends "res://scenes/pieces/LogicPiece.gd"

var current_mv_state := 0
var mv_states: Array = []

func post_move(_delta: Vector2) -> void:
	# To be overwritten later, for castling or state switching
	var new_mv_state := (current_mv_state + 1) % len(mv_states)
	current_mv_state = new_mv_state
	active_mvs = mv_states[new_mv_state]
