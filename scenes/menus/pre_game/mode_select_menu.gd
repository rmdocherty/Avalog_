extends Node2D

var sprs: Array[AnimatedSprite2D] = []

# ======================== INIT METHODS ========================
func _ready() -> void:
	# Loop through each player, init sprites and names
	var names = [stg.uname_1, stg.uname_2]
	for i in [1, 2]:
		set_names_init(i, names[i - 1])
		var spr = set_sprites_init(i)
		sprs.push_back(spr)
		set_faction(stg.chosen_factions[i - 1], i - 1)
	change_spr_palette(1, 1)
	if stg.network == cst.network_types.ONLINE:
		$Canv/Cont/PlayButtons/OnlineOptions.show()
		$Canv/Cont/SpritesMapFactions/SpritesMapBox/P2Parent/Sprite.hide()
		$Canv/Cont/SpritesMapFactions/NameCont/P2.hide()
		$Canv/Cont/SpritesMapFactions/Factions/P2.hide()
		$Canv/Cont/SpritesMapFactions/NameCont/P1/Name.editable = false

func set_sprites_init(i: int) -> AnimatedSprite2D:
	# Play passive anim, flip enemy sprite, set shader parameters
	var node_str := "Canv/Cont/SpritesMapFactions/SpritesMapBox/P%sParent/Sprite"
	var spr: AnimatedSprite2D = get_node(node_str % str(i))
	spr.play("%s_passive" % str(stg.chosen_factions[i-1]))
	if i == 2:
		spr.flip_h = true
	spr.material.set_shader_parameter("original_palette_num", 0)
	return spr

func set_names_init(i: int, player_name: String) -> void:
	var node_str := "Canv/Cont/SpritesMapFactions/NameCont/P%s/Name"
	var line_edit: LineEdit = get_node(node_str % str(i))
	line_edit.text = player_name
	
# ======================== GUI OPTION METHODS ========================
func game_mode_changed(game_mode: int) -> void:
	stg.mode = game_mode as cst.modes
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
			set_faction(stg.chosen_factions[i - 1], i - 1)

func time_changed(idx: int) -> void:
	const times := [5, 10, 30, 999]
	stg.total_time_min = times[idx]

func name_changed(text: String, player: int) -> void:
	if player == 0:
		stg.uname_1 = text
	else:
		stg.uname_2 = text

func palette_picked(palette: int, player: int) -> void:
	stg.replace_palettes[player + 2] = palette

func change_spr_palette(palette: int, spr_idx: int) -> void:
	sprs[spr_idx].material.set_shader_parameter("replace_palette_num", palette)
	palette_picked(palette, spr_idx)

func set_faction(faction: int, player: int) -> void:
	stg.chosen_factions[player] = faction
	stg.replace_palettes[player] = faction
	# Switch to new faction's sprites
	sprs[player].play(("%s_passive" % str(faction)))
	sprs[player].material.set_shader_parameter("original_palette_num", faction)

func set_map(faction: int) -> void:
	stg.chosen_map = faction as cst.factions
	$Canv/Cont/SpritesMapFactions/SpritesMapBox/MapParent/Map.play(str(faction))

func go_back() -> void:
	hlp.load_child_remove_parent("res://scenes/menus/pre_game/main_menu.tscn", self)

# ======================== PLAY BUTTONS ========================
func play() -> void:
	time_changed($Canv/Cont/TimeControl/Picker.selected)
	game_mode_changed($Canv/Cont/GameMode/Picker.selected)
	if stg.mode == cst.modes.DRAFT:
		pass
	elif stg.network == cst.network_types.LOCAL:
		var game_path := "res://scenes/game/graphics/gfx_game_manager.tscn"
		var child: Node = load(game_path).instantiate()
		get_tree().get_root().add_child(child)
		child.init(stg.chosen_fen)
		get_tree().get_root().remove_child(self)
	elif stg.network == cst.network_types.ONLINE:
		stg.look_type = cst.look_types.AUTO
		hlp.load_child_remove_parent("res://scenes/menus/pre_game/BrowseGames.tscn", self)

func host() -> void:
	stg.look_type = cst.look_types.HOST
	hlp.load_child_remove_parent("res://scenes/menus/pre_game/BrowseGames.tscn", self)

func browse() -> void:
	stg.look_type = cst.look_types.BROWSE
	hlp.load_child_remove_parent("res://scenes/menus/pre_game/BrowseGames.tscn", self)
