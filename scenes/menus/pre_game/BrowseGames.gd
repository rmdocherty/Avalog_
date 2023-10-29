extends Node2D

var game_filter := -1
var time_filter := -1

var time_elapsed: float = 0
var UPDATE_T: float = 1.

var selected_idx: int = -1
var data: Array = [["Lancelot", 0, 10], ["Merlin", 1, 999], ["Percival", 2, 15], ["Accolon", 1, 5], ["Foo", 0, 5], ["Lancelot", 0, 10], ["Merlin", 1, 999], ["Percival", 2, 15], ["Accolon", 1, 5], ["Foo", 0, 5], ["Lancelot", 0, 10], ["Merlin", 1, 999], ["Percival", 2, 15], ["Accolon", 1, 5], ["Foo", 0, 5]]

var game_names: Array[String] = ["Classic", "Draft", "Custom"]
var times: Array[int] = [-1, 5, 10, 30, 999]

var auto_joined = false

# ======================== DISPLAY ========================
func _get_space(n: int) -> String:
	# Meant to acheieve uniform spacing between usernames, game modes and times but doesn't.
	var out := ""
	for i in range(n):
		out += " "
	return out

func get_item_str(item: Array) -> String:
	# Get text to insert into the game list
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
	# Insert item=[username, game mode, time control, lobby_id] into game list
	var entry := get_item_str(item)
	game_list.add_item(entry)
	var idx = game_list.item_count - 1
	game_list.set_item_tooltip_enabled(idx, false)
	# Show your hosted lobby if applicable
	if look == cst.look_types.HOST && first == false:
		game_list.set_item_disabled(idx, true)
	elif look == cst.look_types.HOST && first == true:
		game_list.select(idx)
		game_list.set_item_custom_bg_color(idx, Color(0.09, 0.361, 0.545))

func update_item_list(new_data: Array, look: cst.look_types=cst.look_types.HOST) -> void:
	# On lobby list update, refresh game list
	var game_list: ItemList = $Canv/GameList
	game_list.clear()
	if look == cst.look_types.HOST:
		new_data = add_your_lobby(new_data)
	var first_item := true
	for item in new_data:
		add_item(item, game_list, look, first_item)
		first_item = false
	if selected_idx > -1:
		game_list.select(selected_idx)

func add_your_lobby(new_data: Array) -> Array:
	var your_lobby: Array = [stg.uname_1, stg.mode, stg.total_time_min, 0]
	new_data.insert(0, your_lobby)
	return new_data

func update_filter(value_idx: int, picker_idx: int) -> void:
	# When game mode or time filter changes in the menu
	if picker_idx == 0:
		game_filter = value_idx - 1
	else:
		time_filter = times[value_idx]
	_get_lobbies()

func lobby_selected(idx: int) -> void:
	selected_idx = idx
	$Canv/h/h2/Join.disabled = false

func back() -> void:
	_leave_lobby()
	hlp.load_child_remove_parent("res://scenes/menus/pre_game/mode_select_menu.tscn", self)

func init_graphics() -> void:
	if stg.look_type == cst.look_types.HOST:
		$Canv/h/h2/Join.hide()
		$Canv/h/h2/Waiting.show()
		$Canv/Searching.hide()
	elif stg.look_type == cst.look_types.BROWSE:
		$Canv/h/h2/Waiting.hide()
		$Canv/Searching.hide()
	else:
		$Canv/GameList.hide()
		$Canv/h.hide()
		$Canv/Lobbies.hide()


# ======================== STEAM LOGIC ========================
const PACKET_READ_LIMIT: int = 32
var LOBBY_ID: int = 0
var OTHER_PLAYER: Dictionary 
var DATA
var LOBBY_VOTE_KICK: bool = false
var LOBBY_MAX_MEMBERS: int = 2
enum LOBBY_AVAILABILITY {PRIVATE, FRIENDS, PUBLIC, INVISIBLE}


func _ready() -> void:
	# Connect steam signals here
	Steam.lobby_created.connect(_on_lobby_created)
	Steam.lobby_match_list.connect(_on_lobby_match_list)
	Steam.lobby_joined.connect(_on_lobby_joined)
	#Steam.lobby_invite.connect(_on_Lobby_Invite)
	Steam.lobby_chat_update.connect(_on_lobby_chat_update)
	#Steam.join_requested.connect(_on_Lobby_Join_Requested)

	if stg.look_type == cst.look_types.AUTO:
		game_filter = stg.mode
		time_filter = stg.total_time_min

	if stg.look_type == cst.look_types.HOST:
		_create_lobby()
	_get_lobbies()
	init_graphics()

func _create_lobby() -> void:
	if LOBBY_ID == 0: # i.e if not in a lobby already
		Steam.createLobby(Steam.LOBBY_TYPE_PUBLIC, LOBBY_MAX_MEMBERS)

func _on_lobby_created(connection: int, lobby_id: int) -> void:
	if connection == 1:
		# Set the lobby ID
		LOBBY_ID = lobby_id
		print("Created a lobby: "+str(LOBBY_ID))
		# Set this lobby as joinable, just in case, though this should be done by default
		Steam.setLobbyJoinable(LOBBY_ID, true)
		# Set some lobby data
		Steam.setLobbyData(lobby_id, "name", steam.STEAM_USERNAME)
		Steam.setLobbyData(lobby_id, "mode", str(stg.mode))
		Steam.setLobbyData(lobby_id, "time", str(stg.total_time_min))
		Steam.setLobbyData(lobby_id, "private", str(stg.private))
		# Allow P2P connections to fallback to being relayed through Steam if needed
		var RELAY: bool = Steam.allowP2PPacketRelay(true)
		print("Allowing Steam to be relay backup: "+str(RELAY))

func _get_lobbies() -> void:
	# If in private mode, only look at friend's lobbies else look at all public lobbies
	if stg.private:
		var lobbies := _get_friends_lobbies()
		_on_lobby_match_list(lobbies)
	else:
		_get_global_lobbies()


func _get_global_lobbies() -> void:
	# Get list of lobbies that satisfy filters
	if game_filter > -1:
		Steam.addRequestLobbyListStringFilter("mode", str(stg.mode), Steam.LOBBY_COMPARISON_EQUAL)
	if time_filter > -1:
		Steam.addRequestLobbyListStringFilter("time", str(stg.total_time_min), Steam.LOBBY_COMPARISON_EQUAL)
	# List only public lobbies
	Steam.addRequestLobbyListStringFilter("private", str(false), Steam.LOBBY_COMPARISON_EQUAL)
	Steam.addRequestLobbyListDistanceFilter(Steam.LOBBY_DISTANCE_FILTER_FAR)
	Steam.addRequestLobbyListFilterSlotsAvailable(1)
	Steam.addRequestLobbyListResultCountFilter(200)
	Steam.requestLobbyList()


func _get_friends_lobbies() -> Array:
	# Loop over all friends, check if in game and in lobby then add to lust
	var results: Array = []
	for i in range(0, Steam.getFriendCount()):
		var steam_id: int = Steam.getFriendByIndex(i, Steam.FRIEND_FLAG_IMMEDIATE)
		var game_info: Dictionary = Steam.getFriendGamePlayed(steam_id)
		if game_info == {}: # friend is not playing a game
			continue
		else:
			# Check if it's the same game as ours
			var app_id: int = game_info['id']
			var lobby = game_info['lobby']
			if app_id != Steam.getAppID() or lobby is String:
				# Either not in this game, or not in a lobby
				continue
			else:
				results.append(lobby)
	return results

func _on_lobby_match_list(lobbies: Array) -> void:
	var new_data = []
	for LOBBY in lobbies:
		var LOBBY_NAME: String = Steam.getLobbyData(LOBBY, "name")
		var LOBBY_MODE: String = Steam.getLobbyData(LOBBY, "mode")
		var LOBBY_TIME: String = Steam.getLobbyData(LOBBY, "time")
		
		var current_entry = [LOBBY_NAME, int(LOBBY_MODE), int(LOBBY_TIME), LOBBY]
		# no double add lobby
		if LOBBY_ID != LOBBY:
			new_data.push_back(current_entry)
			
	data = new_data
	update_item_list(new_data, stg.look_type)
	# no matching lobbies during auto matchmaking -> create one s.t others can join
	if stg.look_type == cst.look_types.AUTO and len(new_data) == 0 and auto_joined == false:
		stg.look_type = cst.look_types.HOST
		auto_joined = true
		_create_lobby()
	# otherwise auto join first matching lobby
	elif stg.look_type == cst.look_types.AUTO and len(new_data) > 0 and auto_joined == false:
		var join_lobby: int = lobbies[0]
		if LOBBY_ID != join_lobby:
			stg.look_type = cst.look_types.BROWSE
			auto_joined = true
			_join_lobby(lobbies[0])

func join() -> void:
	var lobby_id = data[selected_idx][3]
	_join_lobby(lobby_id)

func _join_lobby(lobby_id: int) -> void:
	print("Attempting to join lobby "+str(lobby_id)+"...")
	Steam.joinLobby(lobby_id)

func _on_lobby_joined(lobby_id: int, _permissions: int, _locked: bool, response: int) -> void:
	# If joining was successful
	if response == 1:
		LOBBY_ID = lobby_id
		if stg.look_type != cst.look_types.HOST:
			OTHER_PLAYER = _get_other_player()
			start_game(OTHER_PLAYER["steam_id"])
	else:
		var FAIL_REASON: String
		match response:
			2:  FAIL_REASON = "This lobby no longer exists."
			3:  FAIL_REASON = "You don't have permission to join this lobby."
			4:  FAIL_REASON = "The lobby is now full."
			5:  FAIL_REASON = "Uh... something unexpected happened!"
			6:  FAIL_REASON = "You are banned from this lobby."
			7:  FAIL_REASON = "You cannot join due to having a limited account."
			8:  FAIL_REASON = "This lobby is locked or disabled."
			9:  FAIL_REASON = "This lobby is community locked."
			10: FAIL_REASON = "A user in the lobby has blocked you from joining."
			11: FAIL_REASON = "A user you have blocked is in the lobby."
		print(FAIL_REASON)

func _get_other_player() -> Dictionary:
	var MEMBER_STEAM_ID: int = Steam.getLobbyMemberByIndex(LOBBY_ID, 0)
	var MEMBER_STEAM_NAME: String = Steam.getFriendPersonaName(MEMBER_STEAM_ID)
	return {"steam_id":MEMBER_STEAM_ID, "steam_name":MEMBER_STEAM_NAME}

func _on_lobby_join_requested(lobby_id: int, friendID: int) -> void:
	# Called when user clicks steam invite/friends list whilst in-game
	var OWNER_NAME: String = Steam.getFriendPersonaName(friendID)
	print("Joining "+str(OWNER_NAME)+"'s lobby...")
	# Attempt to join the lobby
	_join_lobby(lobby_id)

func _on_lobby_chat_update(_lobby_id: int, change_id: int, _making_change_id: int, chat_state: int) -> void:
	# Get the user who has made the lobby change
	var CHANGER: String = Steam.getFriendPersonaName(change_id)
	# If a player has joined the lobby and you're hosting, store their info
	if chat_state == 1 and stg.look_type == cst.look_types.HOST:
		OTHER_PLAYER = _get_other_player()
		OTHER_PLAYER = {"steam_id":change_id, "steam_name":CHANGER}
		start_game(change_id)

func _leave_lobby() -> void:
	if LOBBY_ID != 0:
		Steam.leaveLobby(LOBBY_ID)

func _process(delta: float) -> void:
	if time_elapsed > UPDATE_T:
		_get_lobbies()
		time_elapsed = 0
	time_elapsed += delta

func _notification(what):
	# Close lobby if leaving early
	if what == MainLoop.NOTIFICATION_PREDELETE:
		_leave_lobby()

func adjust_half_fen() -> String:
	# Loop through and prepend faction to half fen
	var out := ""
	for char in stg.half_FEN:
		if char == "/":
			out += char
		elif char.is_valid_int():
			pass
		else:
			out += cst.fen_faction_lookup[stg.chosen_factions[0]]
			out += char
	return out

func start_game(other_player_id: int) -> void:
	# The p2p node inn gfx game manager will now handle connections and setting up the game
	stg.OTHER_PLAYER_ID = other_player_id
	stg.uname_2 = OTHER_PLAYER["steam_name"]
	
	if stg.mode == cst.modes.CUSTOM:
		stg.half_FEN = adjust_half_fen()
	
	if stg.mode == cst.modes.DRAFT: # if draft mode assign other player & load draft menu
		var game_path := "res://scenes/menus/draft/DraftMenu.tscn"
		var child: Node = load(game_path).instantiate()
		get_tree().get_root().add_child(child)
		queue_free()
	else:
		var game_path := "res://scenes/game/graphics/gfx_game_manager.tscn"
		var child: Node = load(game_path).instantiate()
		get_tree().get_root().add_child(child)
		get_tree().get_root().remove_child(self)
