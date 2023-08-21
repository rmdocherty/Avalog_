extends Node2D

const GraphicalPiece := preload("res://scenes/pieces/graphics/GraphicalPiece.tscn")

#const colours: Array[Color] = [Color.GREEN_YELLOW, Color.DARK_GREEN]
const colours: Array[Color] = [Color.BLANCHED_ALMOND, Color.SADDLE_BROWN]
var gfx_offset := Vector2(310, 110)#hlp.norm_to_iso(Vector2(0.5, 0.5)) * cst.BOARD_DRAW_SCALE

@onready var board := $board


func draw_flat_board(h: int, w: int) -> void:
	# Loop and draw coloured rectangles
	for y in range(h):
		for x in range(w):
			var colour := colours[(x + y) % 2]
			var p0 := cst.LOGIC_SQ_W * cst.FLAT_DRAW_SCALE * Vector2(x, y) + gfx_offset
			const size := cst.LOGIC_SQ_W * cst.FLAT_DRAW_SCALE * Vector2(1, 1)
			var rect := Rect2(p0, size)
			draw_rect(rect, colour)


func _draw() -> void:
	if cst.draw_iso == false:
		draw_flat_board(8, 8)

func _ready() -> void:
	board.apply_scale(cst.BOARD_DRAW_SCALE)
	board.play(str(cst.chosen_map))
	if cst.draw_iso == true:
		board.show()
