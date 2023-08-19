extends Area2D


const wall = preload("res://scenes/game/board/Wall.tscn")
var walls: Array  = []

func init(h: int, w: int, offset: Vector2) -> void:
	init_walls(h, w, offset)


func add_wall(pos: Vector2, size: Vector2) -> void:
	var wall_body = wall.instantiate()
	wall_body.init(pos, size)
	add_child(wall_body)
	walls.push_back(wall_body)


func init_walls(h: int, w: int, pos_offset: Vector2) -> void:
	var offset := -1 * cst.LOGIC_SQ_W * Vector2(0.5, 0.5) + pos_offset
	const size := cst.WALL_SIZE
	var top_wall_pos := offset + 0.5 * cst.LOGIC_SQ_W * Vector2(w, 0) + Vector2(0, -size/2.)
	var bot_wall_pos := offset + 0.5 * cst.LOGIC_SQ_W * Vector2(w, 2 * h) + Vector2(0, size/2.)
	var left_wall_pos := offset + 0.5 * cst.LOGIC_SQ_W * Vector2(0, h) + Vector2(-size/2., 0)
	var right_wall_pos := offset + 0.5 * cst.LOGIC_SQ_W * Vector2(2 * w, h) + Vector2(size/2., 0)
	var wall_positions := [top_wall_pos, bot_wall_pos, left_wall_pos, right_wall_pos]
	var wall_sizes := [Vector2(1.5 * cst.LOGIC_SQ_W * w, size), Vector2(1.5 * cst.LOGIC_SQ_W * w, size), Vector2(size, cst.LOGIC_SQ_W * h), Vector2(size, cst.LOGIC_SQ_W * h)]
	for i in range(4):
		add_wall(wall_positions[i], wall_sizes[i])
