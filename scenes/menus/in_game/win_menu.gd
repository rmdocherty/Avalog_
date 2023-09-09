extends Control

var confetti_class = preload("res://scenes/menus/in_game/fake_confetti_particles.tscn")
var player_names: Array[String] = [stg.uname_1, stg.uname_2]

func show_winner(win_colour: int) -> void:
	show()
	var is_local := (stg.network == cst.network_types.LOCAL)
	var has_won := is_local || (stg.singleplayer_colour == win_colour && not is_local )
	if has_won:
		var confetti = confetti_class.instantiate()
		add_child(confetti)
	$Outer/Contents/v/Winner.text = player_names[win_colour] + " wins!"

func main_menu() -> void:
	var home_menu = load("res://scenes/menus/pre_game/main_menu.tscn").instantiate()
	get_tree().get_root().add_child(home_menu)
	get_tree().get_root().remove_child(get_parent().get_parent())

func rematch() -> void:
	if stg.network == cst.network_types.LOCAL:
		var mode_menu = load("res://scenes/menus/pre_game/mode_select_menu.tscn").instantiate()
		get_tree().get_root().add_child(mode_menu)
		get_tree().get_root().remove_child(get_parent().get_parent())

func quit() -> void:
	get_tree().quit()

func _ready():
	pass
	#show_winner(cst.colour.WHITE)
