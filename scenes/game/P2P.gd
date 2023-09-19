extends Node

signal move_sent
signal emote_sent
signal game_start

var connected: bool = stg.OTHER_PLAYER_ID > -1 and stg.network == cst.network_types.ONLINE

func _ready() -> void:
	if connected:
		Steam.p2p_session_request.connect(_on_P2P_session_request)
		Steam.p2p_session_connect_fail.connect(_on_P2P_session_connect_fail)
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
	_send_P2P_packet(stg.OTHER_PLAYER_ID, {"message":"handshake", "from":steam.STEAM_ID})


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


func _send_P2P_packet(target: int, packet_data: Dictionary) -> void:
	var SEND_TYPE: int = Steam.P2P_SEND_RELIABLE
	var CHANNEL: int = 0

	var DATA: PackedByteArray
	DATA.append_array(var_to_bytes(packet_data))
	Steam.sendP2PPacket(target, DATA, SEND_TYPE, CHANNEL)


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
