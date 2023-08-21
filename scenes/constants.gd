extends Node

# Constants
enum network_types {LOCAL, ONLINE}
enum modes {CLASSIC, DRAFT, CUSTOM}
enum factions {ALBION, ROME, BRETAGNE, TURKIYE, MORGANA}

enum mv_type {NORMAL, JUMPING, RANGED, NO_ATTACK}
enum draw_type {LINE, RADIAL}
enum colour {WHITE, BLACK, NONE}
enum collide_layers {NONE, PIECES, MOUSE, GFX}

const LOGIC_SQ_W := 50
const LOGIC_PIECE_RADIUS := 14

const WALL_SIZE: float = 100

const ISO := Vector2(16, 8) # 8 is good
const BOARD_DRAW_SCALE := Vector2(3.75, 3.75)
const FLAT_DRAW_SCALE := Vector2(1.3, 1.3)
const PIECE_DRAW_SCALE := Vector2(2.5, 2.5)

# FEN strings
const fen_faction_lookup = ["a", "i", "f", "t", "m"]
const faction_lookup = ["a", "r", "b", "t", "m"]

const full_board = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR"

# Game variables: updated during runtime
var network := network_types.LOCAL
var mode := modes.CLASSIC

var chosen_factions: Array[int] = [factions.ALBION, factions.ALBION]
# in order p1 original, p2 original, p1 remap, p2 remap
var replace_palettes: Array[int] = [chosen_factions[0], chosen_factions[1], 0, 0]
var chosen_map := factions.ALBION

var uname_1 := "Player 1"
var uname_2 := "Player 2"

var total_time_min := 5
var total_time_seconds := 0

var draw_iso := true

