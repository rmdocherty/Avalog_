extends Node
# from godot steam how-to
# Steam variables
var IS_OWNED: bool = false
var IS_ONLINE: bool = false
var STEAM_ID: int = 0
var STEAM_USERNAME := ""

signal init_failed

func _ready() -> void:
	_initialize_Steam()
	_check_command_line()
	Steam.join_requested.connect(join_lobby_from_steam)

func _process(_delta: float) -> void:
	Steam.run_callbacks()
	# If joining from steam menu whilst in-game
	

func _initialize_Steam() -> void:
	var INIT: Dictionary = Steam.steamInit()
	print("Did Steam initialize?: "+str(INIT))

	if INIT['status'] != 1:
		print("Failed to initialize Steam. "+str(INIT['verbal']))
		init_failed.emit()
	else:
		IS_ONLINE = Steam.loggedOn()
		STEAM_ID = Steam.getSteamID()
		IS_OWNED = Steam.isSubscribed()
		STEAM_USERNAME = Steam.getPersonaName()
		print("Hello " + STEAM_USERNAME)

func _check_command_line() -> void:
	# If joining w/out game loaded
	var ARGUMENTS: Array = OS.get_cmdline_args()
	if ARGUMENTS.size() > 0:
		if ARGUMENTS[0] == "+connect_lobby":
			if int(ARGUMENTS[1]) > 0:
				print("CMD Line Lobby ID: "+str(ARGUMENTS[1]))
				join_lobby_from_steam(int(ARGUMENTS[1]))

func join_lobby_from_steam(lobby_id: int, _friend_id: int=0) -> void:
	var child: Node = load("res://scenes/menus/pre_game/BrowseGames.tscn").instantiate()
	get_tree().get_root().add_child(child)
	child._join_Lobby(lobby_id)
	get_tree().get_root().remove_child(get_tree().current_scene)
