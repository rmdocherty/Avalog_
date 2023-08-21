extends Node2D

var sprs: Array[AnimatedSprite2D] = []

# INIT METHODS
func _ready() -> void:
	# Loop through each player, init sprites and names
	var names = [cst.uname_1, cst.uname_2]
	for i in [1, 2]:
		if cst.network == cst.network_types.LOCAL:
			set_names_init(i, names[i - 1])
		var spr = set_sprites_init(i)
		sprs.push_back(spr)
		set_faction(cst.chosen_factions[i - 1], i - 1)
	change_spr_palette(1, 1)
	if cst.network == cst.network_types.ONLINE:
		$Canv/Cont/PlayButtons/OnlineOptions.show()

func set_sprites_init(i: int) -> AnimatedSprite2D:
	# Play passive anim, flip enemy sprite, set shader parameters
	var node_str := "Canv/Cont/SpritesMapFactions/SpritesMapBox/P%sParent/Sprite"
	var spr: AnimatedSprite2D = get_node(node_str % str(i))
	spr.play("%s_passive" % str(cst.chosen_factions[i-1]))
	if i == 2:
		spr.flip_h = true
	spr.material.set_shader_parameter("original_palette_num", 0)
	return spr

func set_names_init(i: int, player_name: String) -> void:
	var node_str := "Canv/Cont/SpritesMapFactions/NameCont/P%s/Name"
	var line_edit: LineEdit = get_node(node_str % str(i))
	line_edit.text = player_name
	
# GUI OPTION METHODS
func game_mode_changed(game_mode: int) -> void:
	cst.mode = game_mode as cst.modes
	# Hide faction picker if not CUSTOM game mode
	var node_str := "Canv/Cont/SpritesMapFactions/Factions/P%s"
	for i in [1, 2]:
		var dropdown: OptionButton = get_node(node_str % str(i))
		dropdown.hide()
		if game_mode == cst.modes.CUSTOM:
			dropdown.show()
		if game_mode == cst.modes.DRAFT:
			sprs[i - 1].play(("%s_passive" % str(-1)))
		elif game_mode == cst.modes.CLASSIC:
			set_faction(0, i - 1)
		else:
			set_faction(cst.chosen_factions[i - 1], i - 1)

func time_changed(idx: int) -> void:
	const times := [5, 10, 30, 999]
	cst.total_time_min = times[idx]

func name_changed(text: String, player: int) -> void:
	if player == 0:
		cst.uname_1 = text
	else:
		cst.uname_2 = text

func palette_picked(palette: int, player: int) -> void:
	cst.replace_palettes[player + 2] = palette

func change_spr_palette(palette: int, spr_idx: int) -> void:
	sprs[spr_idx].material.set_shader_parameter("replace_palette_num", palette)
	palette_picked(palette, spr_idx)

func set_faction(faction: int, player: int) -> void:
	cst.chosen_factions[player] = faction
	cst.replace_palettes[player] = faction
	# Switch to new faction's sprites
	sprs[player].play(("%s_passive" % str(faction)))
	sprs[player].material.set_shader_parameter("original_palette_num", faction)

func set_map(faction: int) -> void:
	cst.chosen_map = faction as cst.factions
	$Canv/Cont/SpritesMapFactions/SpritesMapBox/MapParent/Map.play(str(faction))

# PLAY BUTTONS
func play() -> void:
	if cst.mode == cst.modes.DRAFT:
		pass
	else:
		var game_path := "res://scenes/game/graphics/gfx_game_manager.tscn"
		hlp.load_child_remove_parent(game_path, self)
