extends Area2D

const colour := cst.colour.NONE
const piece_char := "wall"

func init(pos: Vector2, size: Vector2):
	position = pos
	$Collision.shape.size = size
