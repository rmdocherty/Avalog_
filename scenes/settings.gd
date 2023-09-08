extends Node

var ANIM_SPEED := 1.
var ANIM_ON := true
var LINE_DRAW_WIDTH := 0.22 # was 0.2 iirc

var PIECE_DRAW_SCALE := Vector2(2.2, 2.2)#Vector2(2.5, 2.5) # defo add this as a slider - 2 is interesting

# FEN strings
const full_board := "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR"
const test := "8/1P6/8/p7/1P6/7p/2p4P/R3K2R"
var chosen_fen := test #test

# Game variables: updated during runtime
var network := cst.network_types.LOCAL
var mode := cst.modes.CLASSIC
var display_mode := "windowed"

var chosen_factions: Array[int] = [cst.factions.ALBION, cst.factions.ALBION]
# in order p1 original, p2 original, p1 remap, p2 remap
var replace_palettes: Array[int] = [chosen_factions[0], chosen_factions[1], 0, 1]
var chosen_map := cst.factions.ALBION

var uname_1 := "Arthur"
var uname_2 := "Lancelot"

var total_time_min := 5
var total_time_seconds := 0

var draw_iso := true

var master_vol := 0.5
var music_vol := 0.5
var effects_vol := 0.5
