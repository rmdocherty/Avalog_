extends Node
# if this gets too big, split into 3: constants, settings, helpers 

enum network_types {LOCAL, ONLINE}
enum modes {CLASSIC, DRAFT, CUSTOM}
enum factions {ALBION, ROME, BRETAGNE, TURKIYE, MORGANA}

enum mv_type {NORMAL, JUMPING, RANGED, NO_ATTACK}
enum draw_type {LINE, RADIAL}
enum colour {WHITE, BLACK, NONE}

const LOGIC_SQ_W := 50
const LOGIC_PIECE_RADIUS := 14

enum collide_layers {NONE, PIECES, MOUSE, GFX}

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


func load_child_remove_parent(node_path: String, parent: Node) -> void:
	var child: Node = load(node_path).instantiate()
	get_tree().get_root().add_child(child)
	get_tree().get_root().remove_child(parent)
