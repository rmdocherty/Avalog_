extends Node2D
var helper: mv_helper = mv_helper.new()
var mvs = helper.get_line_mvs([Vector2(0, 1), Vector2(1, 0), Vector2(-1, 0), Vector2(0, -1)], cst.mv_type.NORMAL)
var piece = preload("res://scenes/pieces/LogicPiece.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var p: Area2D = piece.instantiate()
	var q: Area2D = piece.instantiate()
	p.position = Vector2(200, 200)
	q.position = Vector2(200, 245)
	q.colour = cst.colour.BLACK
	add_child(p)
	add_child(q)
	
	var start2 = Time.get_ticks_usec()
	var out2 = q.get_valid_moves(mvs)
	var end2 = Time.get_ticks_usec()
	print(out2, end2-start2)
	var start = Time.get_ticks_usec()
	var out = p.get_valid_moves(mvs)

	p.move(Vector2(200, 224500))
	var end = Time.get_ticks_usec()
	print(out, end-start)
	