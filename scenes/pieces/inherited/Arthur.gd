extends "res://scenes/pieces/LogicPiece.gd"

var extra_moves: Array[Vector2] = []
var castling_vectors: Array[Vector2] = [Vector2(1, 0), Vector2(-1, 0)]
var castles: Array = [0, 0]

func get_all_moves() -> Array:
	# Loop through all active moves attribute, find valid moves and assign to nested_valid moves attr
	var output: Array = []
	for mv in active_mvs:
		output.push_back(get_valid_moves((mv)))
	if moved == false:
		get_extra_moves(castling_vectors, output)
	nested_valid_moves = output
	return nested_valid_moves

func get_extra_moves(extra_mvs: Array[Vector2], old_mvs: Array) -> void:
	"""Loop over castling vectors, raycast and check if collider is rook of same colour. If so,
	overwrite the corresponding old horizontal move vectors to include those rooks. """
	if state != states.DEAD and moved == false:
		var castle_vec_count := 0
		for m in extra_mvs:
			var castle_vec := 20 * m
			var ray_start  := Vector2(0, 0)
			var ray_target := cst.LOGIC_SQ_W * castle_vec

			shape_cast.position = ray_start
			shape_cast.target_position = ray_target
			shape_cast.force_shapecast_update()
			var collide_count: int = shape_cast.get_collision_count()
			if collide_count > 0:
				var collide = shape_cast.get_collider(0)
				if collide.colour == colour and collide.piece_char == "r":
					var delta_norm := (ray_target - ray_start).normalized()
					var collide_pos: Vector2 = shape_cast.get_collision_point(0)
					var collide_obj := shape_cast.get_collider(0)
					var end_pos := map_collision_to_point(delta_norm, ray_target, collide_pos, collide_obj, cst.mv_type.NO_ATTACK)
					castles[castle_vec_count] = collide
					old_mvs[0][0][castle_vec_count + 2] = ray_start
					old_mvs[0][1][castle_vec_count + 2] = end_pos
			castle_vec_count += 1
