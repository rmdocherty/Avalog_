extends Control

const MOVE_SPEED: float = -18
const WRAP_ROUND_Y: int = -1250
const RESET_Y: int = 700
var moving: bool = false

func back() -> void:
	hlp.load_child_remove_parent("res://scenes/menus/pre_game/main_menu.tscn", self)

func parse_entry(key: String, value) -> void:
	var current_str := ""
	current_str += key
	if value is String:
		current_str = current_str + " " + value
		add_text_node(current_str)
	elif value is Array:
		add_text_node("")
		add_text_node(key, true)
		for item in value:
			parse_entry("", item)

func add_text_node(s: String, header: bool=false) -> void:
	var node: Label = Label.new()
	var new_theme = load("res://assets/menus/styles/mode_select_theme.tres")
	node.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	node.theme = new_theme
	node.text = s
	if header:
		node.add_theme_font_size_override("font_size", 40)
	$Control.add_child(node)

func _ready():
	$Control.position.y += 30
	for key in data:
		var value = data[key]
		parse_entry(key, value)
	await get_tree().create_timer(0.75).timeout
	moving = true
	
	
	
	#$Control.position = Vector2(0, 0)

func _process(delta: float):
	if moving:
		$Control.position.y += delta * MOVE_SPEED
	if $Control.position.y < WRAP_ROUND_Y:
		$Control.position.y = RESET_Y

var data = {
	"Created by:": "Ronan Docherty",
	"Music": ["Olly Flaig"],
	"SFX": [
		"Adapted from Freesound", 
		"Footsteps - audioninja001"
		],
	"Art": [
		"Sprites adapted from Gustavo Vituri",
		"Desk & Book by Humble Pixel",
		"Confetti script adapted from hiulit",
	],
	"Fonts": [
		"Bitfantasy by Nimble Beasts Collective",
		"Pixuf by erytau"
	],
	"Software": [
		"Godot Game Engine",
		"Aseprite Sprite Editor",
		"Tiled Map Editor",
		"Godot Steam Library",
		"rfxgen fx generator",
		"",
		""
	],
	"": [
		"Avalog = Avalon (mystical arthurian island) + Analog (chess)",
		"do you like my joke tell me i'm clever better yet tell other people i'm clever"
	],
}
