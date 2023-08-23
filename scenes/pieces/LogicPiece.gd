extends Area2D
class_name  LogicPiece

@export var colour: int = cst.colour.WHITE
@export var faction_char: String = "a"
@export var piece_char: String = "p"
@onready var shape_cast: ShapeCast2D = $ShapeCast

signal piece_taken
enum states {IDLE, MOVED, DEAD}
var state = states.IDLE

var active_mvs: Array = []
var nested_valid_moves: Array = []

func _ready() -> void:
	# Set radii of shape stuff
	shape_cast.shape.radius = cst.LOGIC_PIECE_RADIUS
	$Collision.shape.radius = cst.LOGIC_PIECE_RADIUS
	
	add_to_group("pieces")

func get_all_moves() -> void:
	# Loop through all active moves attribute, find valid moves and assign to nested_valid moves attr
	var output: Array = []
	for mv in active_mvs:
		output.push_back(get_valid_moves((mv)))
	nested_valid_moves = output


func get_valid_moves(mv: MoveVector) -> Array[Array]:
	"""For each vector in move vector, raycast from the start vec to end vec. If a collision is
	found (either enemy, friend or wall), map the parameters to an end position."""
	var start_points: Array[Vector2] = []
	var end_points: Array[Vector2] = []
	for i in range(mv.N):
		var end_pos: Vector2
		var ray_start: Vector2 = cst.LOGIC_SQ_W * mv.from_arr[i]
		var ray_target: Vector2 = cst.LOGIC_SQ_W * (mv.to_arr[i] - mv.from_arr[i])
		shape_cast.position = ray_start
		shape_cast.target_position = ray_target
		shape_cast.force_shapecast_update()

		var collide_count: int = shape_cast.get_collision_count()
		if collide_count > 0:
			var collide_obj: Area2D = shape_cast.get_collider(0)
			var collide_pos: Vector2 = shape_cast.get_collision_point(0)
			var delta_norm := (ray_target - ray_start).normalized()
			end_pos = map_collision_to_point(delta_norm, ray_target, collide_pos, collide_obj, mv.move_type)
		else:
			end_pos = cst.LOGIC_SQ_W * mv.to_arr[i]
		start_points.push_back(ray_start)
		end_points.push_back(end_pos)
	return [start_points, end_points]
# in graphics, loop over every mv (& get types) and every start-end to do graphics stuff

func map_collision_to_point(norm_m: Vector2, ray_end: Vector2, collision_point: Vector2,
							collide_obj: Area2D, mv_type: cst.mv_type) -> Vector2:
	"""Given collision with object, get correct endpoint for a raycast with given mv_type.
	For ranged/no_attack, do nothing if enemy or ally. If line and ally, do nothing, if enemy add
	extra distance to allow taking. If jumping and ally, return 0, if enemy return target position.
	Written to be 'branchless' using int flags rather than if/else blocks (probably an unnecessary optimization)."""
	var epsilon :=  0.5 * norm_m # small offset to avoid same colour collisions
	var collision_point_to_self := collision_point - global_position
	var allowed_end_point := collision_point_to_self.length() * norm_m - cst.LOGIC_PIECE_RADIUS * norm_m - epsilon
	
	var is_attacking: bool = (collide_obj.colour != self.colour) and (collide_obj.colour != cst.colour.NONE)
	var is_line: bool = (mv_type == cst.mv_type.NORMAL)
	var is_jumping: bool = (mv_type == cst.mv_type.JUMPING)
	var attack := int(is_attacking)
	var line := int(is_line)
	var jump := int(is_jumping)
	
	var line_attack := 2 * cst.LOGIC_PIECE_RADIUS * norm_m
	var line_dist := (line * allowed_end_point) + (line * attack * line_attack)
	var jump_dist := (jump * attack * ray_end) + (1 - jump * attack) * Vector2(0, 0)

	var end_point := line_dist + jump_dist
	return end_point


func move(pos: Vector2) -> void:
	state = states.MOVED
	var delta: Vector2 = pos - position
	position = pos
	post_move(delta)


func post_move(_delta: Vector2) -> void:
	# To be overwritten later, for castling or state switching
	pass


func on_overlap(area: LogicPiece) -> void:
	# If enemy piece impinges on this, delete
	print(area.colour, colour)
	var is_enemy = area.colour != colour and colour != cst.colour.NONE
	if state == states.IDLE and is_enemy:
		delete()


func delete() -> void:
	# may need to update to be undoable for engine
	collision_layer = 10
	state = states.DEAD
	position = Vector2(-1000, -1000)
	piece_taken.emit()
	print("deleted")
	set_process_input(false)
