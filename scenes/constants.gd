extends Node

# Constants
enum network_types {LOCAL, ONLINE}
enum modes {CLASSIC, DRAFT, CUSTOM}
enum factions {ALBION, ROME, BRETAGNE, TURKIYE, MORGANA}

enum look_types {HOST, BROWSE, AUTO}

enum mv_type {NORMAL, JUMPING, RANGED, NO_ATTACK}
enum draw_type {LINE, RADIAL}
enum colour {WHITE, BLACK, NONE}
enum collide_layers {NONE, PIECES, MOUSE, GFX}

const LOGIC_SQ_W := 50
const LOGIC_PIECE_RADIUS := 14
const Y_OFFSET := -4
const X_OFFSET := -4

const WALL_SIZE: float = 100
const ISO := Vector2(16, 8) # 8 is good

const faction_colours = [Color("#3978a8"), Color("#c23131"), Color("#4a791f"), Color("#fbeb34"), Color("#414040")]

const fen_faction_lookup = ["a", "i", "f", "t", "m"]
const faction_lookup = ["a", "r", "b", "t", "m"]

const BOARD_DRAW_SCALE := Vector2(3.75, 3.75)
const FLAT_DRAW_SCALE := Vector2(1, 1)

const PROJ_SPEED := Vector2(75, 75)
