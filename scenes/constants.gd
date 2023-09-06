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
const Y_OFFSET := -4
const X_OFFSET := -4

const WALL_SIZE: float = 100
const ISO := Vector2(16, 8) # 8 is good

const fen_faction_lookup = ["a", "i", "f", "t", "m"]
const faction_lookup = ["a", "r", "b", "t", "m"]

# move below to settings
const ANIM_SPEED := 1.
const ANIM_ON := true
const LINE_DRAW_WIDTH := 0.22 # was 0.2 iirc
const BOARD_DRAW_SCALE := Vector2(3.75, 3.75)
const FLAT_DRAW_SCALE := Vector2(1.3, 1.3)
var PIECE_DRAW_SCALE := Vector2(2.2, 2.2)#Vector2(2.5, 2.5) # defo add this as a slider - 2 is interesting

# FEN strings
const full_board := "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR"
const test := "8/1P6/8/p7/1P6/7p/2p4P/R3K2R"
const chosen_fen := test #test

# Game variables: updated during runtime
var network := network_types.LOCAL
var mode := modes.CLASSIC

var chosen_factions: Array[int] = [factions.ALBION, factions.ALBION]
# in order p1 original, p2 original, p1 remap, p2 remap
var replace_palettes: Array[int] = [chosen_factions[0], chosen_factions[1], 0, 1]
var chosen_map := factions.ALBION

var uname_1 := "Player 1"
var uname_2 := "Player 2"

var total_time_min := 5
var total_time_seconds := 0

var draw_iso := true

