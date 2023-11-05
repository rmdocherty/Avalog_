extends Control

func _init():
	hide()

func init(warning_text: String, show_button: bool) -> void:
	$Outer/Contents/v/Text.text = warning_text
	if show_button == false:
		$Outer/Contents/v/MainMenu.hide()
	show()

func close() -> void:
	queue_free()

func main_menu() -> void:
	#hlp.load_child_remove_parent("res://scenes/menus/pre_game/main_menu.tscn", get_parent().get_parent())
	Music.switch_tracks(Music.tracks.MENU)
	var home_menu = load("res://scenes/menus/pre_game/main_menu.tscn").instantiate()
	get_parent().get_parent().back()
	get_tree().get_root().add_child(home_menu)
	
	get_parent().get_parent().queue_free()

func on_bg_click(_input: InputEvent) -> void:
	var is_click: bool = Input.is_action_just_pressed("click")
	if is_click:
		close()
