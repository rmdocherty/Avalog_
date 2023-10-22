extends "res://scenes/pieces/LogicPiece.gd"
@export var ranged_multiplier := 3.0
var ranged_dist: float = cst.LOGIC_SQ_W * ranged_multiplier
@onready var ranged: Area2D = $Ranged

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set radii of shape stuff
	shape_cast.shape.radius = cst.LOGIC_PIECE_RADIUS
	$Collision.shape.radius = cst.LOGIC_PIECE_RADIUS
	$Ranged/RangedCollision.shape.radius = cst.LOGIC_PIECE_RADIUS

func move(pos: Vector2) -> void:
	state = states.MOVED
	var delta: Vector2 = pos - position
	position = pos
	ranged.position = delta.normalized() * ranged_dist
	moved = true
	post_move(delta)

func get_all_moves(_turn_n: int) -> Array:
	# Loop through all active moves attribute, find valid moves and assign to nested_valid moves attr
	ranged.position = Vector2(0, 0)
	var output: Array = []
	for mv in active_mvs:
		output.push_back(get_valid_moves((mv)))
	nested_valid_moves = output
	return nested_valid_moves

func on_ranged_overlap(area: Area2D) -> void:
	var is_enemy = area.colour != colour and area.colour != cst.colour.NONE
	if is_enemy and (state == states.MOVED || state == states.ATTACKING):
		state = states.ATTACKING
		area.delete()

#plan: in the move call, move the ranged collision N squares forward. Reset its position in get_moves()
# Make sure the circle collides with but is invisible to normal pieces
# have a ranged graphics piece that has the ranged move crosshair etc
