extends Node

signal move_sent(piece_num: int, new_pos: Vector2)
signal emote_sent
signal fen_recieved(half_fen: String)
signal rematch_request

var connected: bool = stg.OTHER_PLAYER_ID > -1 and stg.network == cst.network_types.ONLINE
var is_host := stg.look_type == cst.look_types.HOST

func _ready() -> void:
	if connected:
		Steam.p2p_session_request.connect(_on_P2P_session_request)
		Steam.p2p_session_connect_fail.connect(_on_P2P_session_connect_fail)
	await get_tree().create_timer(0.75).timeout
	if stg.look_type == cst.look_types.HOST and connected:
		_make_P2P_handshake()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if connected:
		_read_P2P_packet()


func _on_P2P_session_request(remote_id: int) -> void:
	#var REQUESTER: String = Steam.getFriendPersonaName(remote_id)
	Steam.acceptP2PSessionWithUser(remote_id)
	_make_P2P_handshake()


func _make_P2P_handshake() -> void:
	print("Sending P2P handshake to the lobby")
	_send_P2P_packet(stg.OTHER_PLAYER_ID, {"type":"handshake", "from":steam.STEAM_ID})


func _read_P2P_packet() -> void:
	var PACKET_SIZE: int = Steam.getAvailableP2PPacketSize(0)
	if PACKET_SIZE > 0:
		var PACKET: Dictionary = Steam.readP2PPacket(PACKET_SIZE, 0)
		if PACKET == {} or PACKET == null:
			print("WARNING: read an empty packet with non-zero size!")
		#var PACKET_SENDER: int = PACKET['steam_id_remote']
		var PACKET_CODE: PackedByteArray = PACKET['data']
		var READABLE: Dictionary = bytes_to_var(PACKET_CODE)
		print("Packet: "+str(READABLE))
		_handle_packet(READABLE)


func _send_P2P_packet(target: int, packet_data: Dictionary) -> void:
	var SEND_TYPE: int = Steam.P2P_SEND_RELIABLE
	var CHANNEL: int = 0

	var DATA: PackedByteArray
	DATA.append_array(var_to_bytes(packet_data))
	Steam.sendP2PPacket(target, DATA, SEND_TYPE, CHANNEL)

func _handle_packet(packet: Dictionary) -> void:
	if packet["type"] == "handshake" and is_host:
		var colour := randi_range(0, 1)
		var other_player_colour := 1 - colour
		stg.player_colour = colour as cst.colour
		var resp_packet = {"type":"setup", "colour":other_player_colour, "half_fen":stg.half_FEN}
		_send_P2P_packet(stg.OTHER_PLAYER_ID, resp_packet)
	if packet["type"] == "setup" and not is_host:
		var colour_set := packet["colour"] as cst.colour
		stg.player_colour = colour_set
		fen_recieved.emit(packet["half_fen"])
		var resp_packet = {"type":"setup_respond", "half_fen":stg.half_FEN}
		_send_P2P_packet(stg.OTHER_PLAYER_ID, resp_packet)
	if packet["type"] == "setup_respond":
		fen_recieved.emit(packet["half_fen"])
	if packet["type"] == "move":
		var piece_n: int = packet["piece_n"]
		var piece_pos: Vector2 = packet["pos"]
		move_sent.emit(piece_n, piece_pos)

func _on_P2P_session_connect_fail(steamID: int, session_error: int) -> void:
	if session_error == 0:
		print("WARNING: Session failure with "+str(steamID)+" [no error given].")
	elif session_error == 1:
		print("WARNING: Session failure with "+str(steamID)+" [target user not running the same game].")
	elif session_error == 2:
		print("WARNING: Session failure with "+str(steamID)+" [local user doesn't own app / game].")
	elif session_error == 3:
		print("WARNING: Session failure with "+str(steamID)+" [target user isn't connected to Steam].")
	elif session_error == 4:
		print("WARNING: Session failure with "+str(steamID)+" [connection timed out].")
	elif session_error == 5:
		print("WARNING: Session failure with "+str(steamID)+" [unused].")
	else:
		print("WARNING: Session failure with "+str(steamID)+" [unknown error "+str(session_error)+"].")

func _close_connection() -> void:
	Steam.closeP2PSessionWithUser(stg.OTHER_PLAYER_ID)

func _notification(what):
	# Close lobby if leaving early
	if what == MainLoop.NOTIFICATION_PREDELETE and connected:
		_close_connection()
