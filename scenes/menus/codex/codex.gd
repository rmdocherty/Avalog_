extends Node2D

#var minigameClass = preload("res://scenes/game/graphics/gfx_game_manager.tscn")
var minigame

var tabClass = preload("res://scenes/menus/codex/Tab.tscn")

var codex_data_script = load("res://scenes/menus/codex/codex_data.gd")
var codex_data: Dictionary = codex_data_script.codex_data
var max_page_idx: int = len(codex_data.keys()) - 1

const faction_names: Array[String] = ["Albion", "Rome", "Bretagne", "Türkiye", "Gore"]
const type_lookup: Array[String] = ["k", "q", "b", "n", "r", "p"]
const page_lookup: Array[int] = [1, 7, 13, 19, 25] #7, 13, 19, 25] update when adding the rest of the pieces.
const piece_types: Array[String] = ["Monarch", "Consort", "Bishop", "Knight", "Rook", "Pawn"]

enum {CLOSED, OPENING, TEXT_APPEAR, OPEN, TEXT_DISAPPEAR, FLIPPING}
var state := CLOSED
var book: Area2D
var sprite: AnimatedSprite2D
var page := 0

func _ready() -> void:
	# Onload, open book after short delay and load text. Also cache the game running in the background
	book = $Parent/Book
	
	load_page_data(0)
	minigame = load("res://scenes/game/graphics/gfx_game_manager.tscn").instantiate()
	$Parent/Book/Page/SubViewportContainer/SubViewport.add_child(minigame)

	minigame.get_node("bg").hide()
	minigame.custom_init(0, "")
	minigame.change_player_each_turn = false
	minigame.get_node("Camera2D").target_zoom = Vector2(1.4, 1.4)
	minigame.get_node("Camera2D").target_pos = Vector2(8, -8)
	
	sprite = book.get_node("Sprite")
	sprite.play("closed")
	
	var timer = get_tree().create_timer(0.1)
	await timer.timeout
	sprite.play("open")
	state = OPENING
	await sprite.animation_finished
	
	state = TEXT_APPEAR
	$Parent/Book/Page.show()
	
	# create a tab per faction that allows for quick access
	for i in range(len(page_lookup)):
		var tab = tabClass.instantiate()
		$Parent/Book.add_child(tab)
		tab.position = Vector2(926, 192 + i * 50)
		tab.init(i)
		await tab.get_node("Hover").get_node("Sprite").animation_finished


func page_click(_viewport, _event: InputEvent, _shape_idx, dir: int) -> void:
	if Input.is_action_just_pressed("click") and state == OPEN:
		turn_to_page(page, page + dir)

func tab_click(faction_idx: int) -> void:
	var new_page = page_lookup[faction_idx]
	turn_to_page(page, new_page)

func turn_to_page(old_idx: int, new_idx: int) -> void:
	# Set limits of pages to go to
	if new_idx >= 31 or new_idx <= -1:
		return
	$Parent/Book/Flip.play()
	$Parent/Book/Page.modulate.a = 0
	$Parent/Book/Page/SubViewportContainer.modulate.a = 0
	if old_idx < new_idx:
		sprite.play("turn_left")
	elif old_idx > new_idx:
		sprite.play("turn_right")
	await sprite.animation_finished
	page = new_idx
	load_page_data(page)
	state = TEXT_APPEAR

func load_page_data(idx: int) -> void:
	var data = codex_data[str(idx)]
	if idx > 0:
		for N in $Parent/Book/Page.get_children():
			N.show()
		var faction_int = data["faction"]
		var type_int = type_lookup.find(data["type"], 0)
		$Parent/Book/Page/Title.text = data["name"]
		$Parent/Book/Page/Faction.text = faction_names[faction_int]
		$Parent/Book/Page/PieceType.text = piece_types[type_int]
		for label in [$Parent/Book/Page/Faction, $Parent/Book/Page/PieceType]:
			label.label_settings.font_color =  cst.faction_colours[faction_int]
		$Parent/Book/Page/RulesText.text = data["tooltip"]
		$Parent/Book/Page/Attribution.text = data["author"]
		
		var AFEN = "8/8/8/4%s%s/8/8/8/8" % [cst.fen_faction_lookup[faction_int], type_lookup[type_int].to_upper()]
		minigame.remove_all()
		var current_factions: Array[cst.factions] = [faction_int, faction_int]
		minigame.player_monarch_factions = current_factions #set this to make pawn moves work
		minigame.custom_init(faction_int, AFEN)
		$ShowLines.start()
	else:
		for N in $Parent/Book/Page.get_children():
			N.hide()
		$Parent/Book/Page/LoreText.show()
	$Parent/Book/Page/LoreText.text = data["lore"]

func show_piece_lines() -> void:
	minigame.all_pieces[0].graphics.mouse_entered_circle()

func _process(delta: float) -> void:
	if state == TEXT_APPEAR:
		$Parent/Book/Page.modulate.a += 1.5 * delta
		$Parent/Book/Page/SubViewportContainer.modulate.a += 1.5 * delta
	
	if $Parent/Book/Page.modulate.a >= 1:
		state = OPEN
	
func back() -> void:
	hlp.load_child_remove_parent("res://scenes/menus/pre_game/main_menu.tscn", self)

