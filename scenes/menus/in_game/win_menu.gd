extends Control

signal rematch_reject
signal rematch_accept
signal rematch_request

var confetti_class = preload("res://scenes/menus/in_game/fake_confetti_particles.tscn")
var player_names: Array[String] = [stg.uname_1, stg.uname_2]
var shown = false

func show_winner(win_colour: int) -> void:
	var correct_player_name := win_colour as cst.colour 
	if shown == true:
		return # early return so we don't double up win screens
	if stg.player_colour == 1: # invert if online and other player
		correct_player_name = 1 - win_colour as cst.colour
	shown = true
	show()
	var confetti = confetti_class.instantiate()
	confetti.colors = confetti.colours_list[stg.replace_palettes[win_colour + 2]]
	add_child(confetti)
	$Outer/Contents/v/Winner.text = player_names[correct_player_name] + " wins!"

func main_menu() -> void:
	Music.switch_tracks(Music.tracks.MENU)
	var home_menu = load("res://scenes/menus/pre_game/main_menu.tscn").instantiate()
	get_tree().get_root().add_child(home_menu)
	get_tree().get_root().remove_child(get_parent().get_parent())

func rematch() -> void:
	if stg.network == cst.network_types.LOCAL:
		var mode_menu = load("res://scenes/menus/pre_game/mode_select_menu.tscn").instantiate()
		get_tree().get_root().add_child(mode_menu)
		get_tree().get_root().remove_child(get_parent().get_parent())
	else:
		#rematch_requested()
		rematch_request.emit()


func rematch_requested() -> void:
	$Outer/Contents/v/r_cont/Rematch.hide()
	$Outer/Contents/v/r_cont/Rematch_text.show()
	$Outer/Contents/v/r_cont/Reject.show()
	$Outer/Contents/v/r_cont/Accept.show()

func rematch_accepted() -> void:
	rematch_accept.emit()

func rematch_rejected() -> void:
	rematch_reject.emit()

func quit() -> void:
	get_tree().quit()

func _ready():
	pass
	#show_winner(cst.colour.WHITE)
