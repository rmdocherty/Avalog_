extends Node2D

var codex_data_script = load("res://scenes/menus/codex/codex_data.gd")
var codex_data: Dictionary = codex_data_script.codex_data
var minigameClass = preload("res://scenes/game/graphics/gfx_game_manager.tscn")

const faction_names := ["Albion", "Rome", "Bretagne", "Ottomans", "Morgana"]
const type_lookup := ["k", "q", "b", "n", "r", "p"]
const piece_types := ["Monarch", "Consort", "Bishop", "Knight", "Rook", "Pawn"]

enum {DISABLED, LOAD_MOVE, ENABLED, PICK_MOVE, REJECT_MOVE}
var state := DISABLED

var faction_idx := 0
var idx := 0
var target_pos := Vector2(0, 0)
var target_rot := 0.0
var speed := randf_range(0.8, 1) * 2

var debug := true

signal pick_page(page_idx)

# Called when the node enters the scene tree for the first time.
func _ready():
	if debug:
		var minigame = minigameClass.instantiate()
		position = Vector2(200, 200)
		init(minigame, 8, 0)
	pick_page.connect(Callable(get_parent().get_parent(), "pick_page"))

func init(minigame, codex_int: int, page_idx: int) -> String:
	var pieceTypeText = load_page_data(codex_int, minigame)
	idx = page_idx
	state = LOAD_MOVE
	return pieceTypeText

func load_page_data(codex_idx: int, minigame) -> String:
	var data: Dictionary = codex_data[str(codex_idx)]
	var faction_int: int = data["faction"]
	faction_idx = faction_int
	var type_int: int = type_lookup.find(data["type"], 0)
	$Hover/Parent/Title.text = data["name"]
	$Hover/Parent/Faction.text = faction_names[faction_int]
	$Hover/Parent/PieceType.text = piece_types[type_int]
	for label in [$Hover/Parent/Faction, $Hover/Parent/PieceType]:
		label.label_settings.font_color =  cst.faction_colours[faction_int]
#		label.label_settings.color = cst.colors[faction_idx]
	$Hover/Parent/RulesText.text = data["tooltip"]
	load_minigame(minigame, cst.fen_faction_lookup[faction_int], type_lookup[type_int])
	return piece_types[type_int] 

func load_minigame(minigame, faction_char: String, piece_char: String) -> void:
	var AFEN = "8/8/8/4%s%s/8/8/8/8" % [faction_char, piece_char.to_upper()]
	if (minigame.get_parent() != null):
		minigame.reparent($Hover/Parent/SubViewportContainer/SubViewport)
	else:
		$Hover/Parent/SubViewportContainer/SubViewport.add_child(minigame)
	minigame.get_node("bg").hide()
	minigame.remove_all()
	minigame.custom_init(0, AFEN)
	minigame.get_node("Camera2D").target_zoom = Vector2(1.1, 1.1)
	minigame.get_node("Camera2D").target_pos = Vector2(-20, -25)
	
func snap():
	var vtexture = $Hover/Parent/SubViewportContainer/SubViewport.get_texture()  #.get_data().get_rect(region)
	var vimage = vtexture.get_image()
	$Hover/Parent/Snap.texture = ImageTexture.create_from_image(vimage)
	$Hover/Parent/Snap.position = Vector2(-8, 10)
	$Hover/Parent/SubViewportContainer.hide()
	$ColorRect.color = Color(0, 0, 0, 0)
	state = DISABLED

func trigger_done():
	snap()
	pick_page.emit(idx)

func _on_hover_click(_viewport, _event: InputEvent, _shape_idx):
	if Input.is_action_just_pressed("click") and state == ENABLED:
		trigger_done()

func _on_hover_mouse_entered():
	if state == ENABLED:
		$ColorRect.color = cst.faction_colours[faction_idx]

func _on_hover_mouse_exited():
	$ColorRect.color = Color(0, 0, 0, 0)

func _process(delta: float):
	if (target_pos - position).length() > 10 and state in [LOAD_MOVE, PICK_MOVE, REJECT_MOVE]:
		var dir: Vector2 = (target_pos - position).normalized()
		position += dir * delta * 180 * speed
	elif state in [LOAD_MOVE, ENABLED] :
		state = ENABLED
	if abs(target_rot - rotation) > 0.1:
		var dir: float = (target_rot - rotation)
		rotation += dir * delta * 1.1

