extends Node

var ANIM_SPEED := 1.
var ANIM_ON := true
var LINE_DRAW_WIDTH := 0.20 # was 0.2 iirc

var PIECE_DRAW_SCALE := Vector2(2.2, 2.2)#Vector2(2.5, 2.5) # defo add this as a slider - 2 is interesting

# FEN strings
const full_board := "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR"

const lasker = "rn3rk1/pbppq1pQ/1p2pb2/4N3/3PN3/3B4/PPP2PPP/R3K2R" #scene 2
const vladimirov = 'r4k1r/1b2bPR1/p4n1B/3p4/4P2P/1q5B/PpP5/1K4R1' #"R4K1R/1B2Bpr1/P4N2/3P4/4p2p/1Q2b2b/pPp5/1k4r1"
const marshall = "5RK1/PP4PP/4P3/4r1q1/3N4/2Q4R/p1p2ppp/5rk1"
const london = "rnbqkb1r/ppp1pppp/5n2/3p4/3P1B2/5N2/PPP1PPPP/RN1QKB1R"
const morphy = "RN2KB1R/P3QPPP/5N2/1P2P1b1/2b1p3/1q6/ppp2ppp/r3k2r"
const marketing := "8/8/8/8/8/8/1k/R"


var half_FEN := "rnbqkbnr/pppppppp/"
var opponent_half_FEN := "rnbqkbnr/pppppppp/"

const test := "r1kQ2pn/1P6/p3B2P/2fr/1P6/7p/2p2prP/R3K2R"
const test_factions := "trinbtqmkbfnir/aptpmpip/"
const test_piece := "8/8/8/4tN/8/8/3p"
const test_shoot = "8/qqqqqq/8/8/8/4tR"

var chosen_fen := "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR"
# Game variables: updated during runtime
var network := cst.network_types.LOCAL
var mode := cst.modes.CLASSIC
var display_mode := "windowed"

var look_type := cst.look_types.AUTO
var private := false
var player_colour: cst.colour = cst.colour.WHITE

var chosen_factions: Array[int] = [cst.factions.ALBION, cst.factions.ALBION]
# in order p1 original, p2 original, p1 remap, p2 remap
var replace_palettes: Array[int] = [chosen_factions[0], chosen_factions[1], 0, 1]
var chosen_map := cst.factions.ALBION

var your_colour := Color(0.29, 0.56, 0.96, 0.8)
var opponent_colour := Color(0.96, 0.29, 0.29, 0.8)
var highlight_colour := Color(0.92, 0.8, 0.2, 0.8)
var inactive_colour := Color("#919191")
var stipple := false

var OTHER_PLAYER_ID: int = -1

var uname_1 := "Player 1"
var uname_2 := "Player 2"

var winning_player := cst.colour.WHITE
var singleplayer_colour := cst.colour.WHITE

var total_time_min := 30
var total_time_seconds := 0

var draw_iso := true
var classic_icons := false

var master_vol := 0.5
var music_vol := 0.5
var effects_vol := 0.5
