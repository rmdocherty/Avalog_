extends "res://scenes/pieces/inherited/MultiStateLogicPiece.gd"

var turn_number: int = 0

var en_passant_class = preload("res://scenes/pieces/inherited/EnPassant.tscn")
var en_passant_node: Node2D
var en_passant_possible := false
var en_passant_turn_n: int = 0

var extra_moves: Array[Vector2] = []

func post_move(delta: Vector2) -> void:
	# To be overwritten later, for castling or state switching
	var new_mv_state := 1
	current_mv_state = new_mv_state
	active_mvs = mv_states[new_mv_state]
	
	var is_long: bool = delta.length() > 1.5 * cst.LOGIC_SQ_W
	var is_vertical: bool = (delta[0] == 0)
	
	if is_long and is_vertical and stg.mode == cst.modes.CLASSIC:
		en_passant_possible = true
		en_passant_node = en_passant_class.instantiate()
		en_passant_turn_n = turn_number
		add_child(en_passant_node)
		en_passant_node.position = -1 * delta.normalized() * cst.LOGIC_SQ_W


func get_all_moves(turn_n: int) -> Array:
	# Loop through all active moves attribute, find valid moves and assign to nested_valid moves attr
	var output: Array = []
	for mv in active_mvs:
		output.push_back(get_valid_moves((mv)))
	var attack_mvs: Array[Array] = get_extra_moves(extra_moves)
	output.push_back(attack_mvs)
	nested_valid_moves = output
	turn_number = turn_n
	
	if en_passant_possible and turn_n - en_passant_turn_n > 1:
		en_passant_node.remove() #remove_timer_start()
		en_passant_possible = false
	
	return nested_valid_moves


func get_extra_moves(extra_mvs: Array[Vector2]) -> Array[Array]:
	var start_points: Array[Vector2] = []
	var end_points: Array[Vector2] = []
	for mv in extra_mvs:
		var end_pos: Vector2
		var ray_start: Vector2 = Vector2(0, 0)
		var ray_target: Vector2 = cst.LOGIC_SQ_W * mv
		shape_cast.position = ray_start
		shape_cast.target_position = ray_target
		shape_cast.set_collision_mask_value(5, 1)
		shape_cast.force_shapecast_update()

		var collide_count: int = shape_cast.get_collision_count()
		if collide_count > 0:
			var collide_obj := shape_cast.get_collider(0)
			if collide_obj.colour != colour and collide_obj.colour != cst.colour.NONE:
				var delta_norm := (ray_target - ray_start).normalized()
				var collide_pos: Vector2 = shape_cast.get_collision_point(0)
				end_pos = map_collision_to_point(delta_norm, ray_target, collide_pos, collide_obj, cst.mv_type.NORMAL)
				start_points.push_back(Vector2(0, 0))
				end_points.push_back(end_pos)
			else:
				start_points.push_back(Vector2(0, 0))
				end_points.push_back(Vector2(0, 0))
		else:
			start_points.push_back(Vector2(0, 0))
			end_points.push_back(Vector2(0, 0))
	
	shape_cast.set_collision_mask_value(5, 0)
	return [start_points, end_points]
