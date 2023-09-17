extends Node2D

var game_filter := -1
var time_filter := -1

var selected_idx: int = -1
var data: Array[Array] = [["Lancelot", 0, 10], ["Merlin", 1, 999], ["Percival", 2, 15], ["Accolon", 1, 5], ["Foo", 0, 5], ["Lancelot", 0, 10], ["Merlin", 1, 999], ["Percival", 2, 15], ["Accolon", 1, 5], ["Foo", 0, 5], ["Lancelot", 0, 10], ["Merlin", 1, 999], ["Percival", 2, 15], ["Accolon", 1, 5], ["Foo", 0, 5]]

var game_names: Array[String] = ["Classic", "Draft", "Custom"]
var times: Array[int] = [-1, 5, 10, 30, 999]

func matches_filter(item: Array, g_filter: int=-1, t_filter: int=-1) -> bool:
	var out = true
	if g_filter > -1 && g_filter != item[1]:
		out = false
	if t_filter > -1 && t_filter != item[2]:
		out = false
	return out

func _get_space(n: int) -> String:
	var out := ""
	for i in range(n):
		out += " "
	return out

func get_item_str(item: Array) -> String:
	var name_str: String = item[0]
	var name_space_n := 30 - len(name_str)
	var name_space := _get_space(name_space_n)
	var game_str: String = game_names[item[1]]
	var game_space_n := 20 - len(game_str)
	var game_space := _get_space(game_space_n)
	var time_name: String = str(item[2]) + "+0"
	if item[2] == 999:
		time_name = "Unlimited"
	return name_str + name_space + game_str + game_space + time_name

func add_item(item: Array, game_list: ItemList, look: cst.look_types, first: bool=false) -> void:
	var entry := get_item_str(item)
	game_list.add_item(entry)
	var idx = game_list.item_count - 1
	game_list.set_item_tooltip_enabled(idx, false)
	if look == cst.look_types.HOST && first == false:
		game_list.set_item_disabled(idx, true)
	elif look == cst.look_types.HOST && first == true:
		game_list.select(idx)
		game_list.set_item_custom_bg_color(idx, Color(0.09, 0.361, 0.545))

func update_item_list(new_data: Array[Array], look: cst.look_types=cst.look_types.HOST) -> void:
	var game_list: ItemList = $Canv/GameList
	game_list.clear()
	if look == cst.look_types.HOST:
		new_data = add_your_lobby(new_data)
	var first_item := true
	for item in new_data:
		if matches_filter(item, game_filter, time_filter) == true:
			add_item(item, game_list, look, first_item)
		first_item = false

func add_your_lobby(new_data: Array[Array]) -> Array[Array]:
	var your_lobby: Array = [stg.uname_1, stg.mode, stg.total_time_min]
	new_data.insert(0, your_lobby)
	return new_data

func update_filter(value_idx: int, picker_idx: int) -> void:
	if picker_idx == 0:
		game_filter = value_idx - 1
	else:
		time_filter = times[value_idx]
	update_item_list(data)

func lobby_selected(idx: int) -> void:
	selected_idx = idx
	$Canv/h/h2/Join.disabled = false

func back() -> void:
	hlp.load_child_remove_parent("res://scenes/menus/pre_game/mode_select_menu.tscn", self)

func _ready() -> void:
	update_item_list(data, stg.look_type)
	if stg.look_type == cst.look_types.HOST:
		$Canv/h/h2/Invite.show()
		$Canv/h/h2/Join.hide()
		$Canv/h/h2/Waiting.show()
		$Canv/Searching.hide()
	elif stg.look_type == cst.look_types.BROWSE:
		$Canv/h/h2/Invite.hide()
		$Canv/h/h2/Waiting.hide()
		$Canv/Searching.hide()
	else:
		$Canv/GameList.hide()
		$Canv/h.hide()
		$Canv/Lobbies.hide()


# add an _process here that polls steam matchmaking
