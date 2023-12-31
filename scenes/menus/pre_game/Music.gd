extends Node2D

enum tracks {MENU, PROC, GAME, TIME, BEGINNING, EMBARK, GROOVY}
var track_names: Array[String] = ["Melancholy", "Procedural", "Peaceful", "Frantic", "Beginning", "Embark", "Groovy"]
@onready var track_nodes: Array[Node] = [$Melancholy, $ProceduralMusic, $Peaceful, $Frantic, $Beginning, $Embark, $Groovy]
var playing_track: tracks
var target_track: int = -1

@onready var procedural = $ProceduralMusic

var FADE_TIME := 2
var current_fade_time := 0.

const default_vol_db := -15
const default_vol_linear := db_to_linear(default_vol_db)


func get_track(track_n: tracks) -> Node:
	var out: Node
	out = track_nodes[track_n]
	return out

func play_track(track_n: tracks) -> void:
	playing_track = track_n
	var audio := get_track(track_n)
	if track_n == 1:
		audio.set_volume_db(default_vol_db)
	else:
		audio.volume_db = default_vol_db
	audio.play()

func switch_tracks(new_track_n: tracks) -> void:
	if new_track_n == playing_track:
		return
	
	var playing_audio := get_track(playing_track)
	var target_audio := get_track(new_track_n)

	var zero_vol_db := linear_to_db(0.01)
	if new_track_n == 1:
		target_audio.set_volume_db(0)
	else:
		target_audio.volume_db = default_vol_db
	target_audio.play()

	# expo tweens as decibels are expo
	if playing_track == 1:
		playing_audio.stop()
	else:
		var tw1 := get_tree().create_tween()
		tw1.tween_property(playing_audio, "volume_db", zero_vol_db, FADE_TIME).set_trans(Tween.TRANS_EXPO)
		tw1.tween_callback(playing_audio.stop)
	
	if new_track_n != 1:
		var tw2 := get_tree().create_tween()
		tw2.tween_property(target_audio, "volume_db", default_vol_db, FADE_TIME).set_trans(Tween.TRANS_EXPO)
	playing_track = new_track_n


func track_timeout() -> void:
	# Loop
	play_track(playing_track)

# Called when the node enters the scene tree for the first time.
func _ready():
	for bus_name in ["Master", "music", "sfx"]:
		var bus := AudioServer.get_bus_index(bus_name)
		AudioServer.set_bus_volume_db(bus, linear_to_db(0.5))
	await get_tree().create_timer(1).timeout
	play_track(tracks.MENU)
