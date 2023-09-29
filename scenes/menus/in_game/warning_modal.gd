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
	hlp.load_child_remove_parent("res://scenes/menus/pre_game/main_menu.tscn", self)

func on_bg_click(_input: InputEvent) -> void:
	var is_click: bool = Input.is_action_just_pressed("click")
	if is_click:
		close()
