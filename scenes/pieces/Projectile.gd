extends Node2D


@export var vel: Vector2 = 7 * cst.PROJ_SPEED
var decrease_sf := 5 * Vector2(1, 1)

var shooting := false

@export var rotate_spr := true

var parent_pos: Vector2
var target_vec: Vector2

var currently_moved_dist: float = 0.0
var to_move_dist: float = 0.0

signal hit_target
# Called when the node enters the scene tree for the first time.


func shoot(start_pos: Vector2, target_pos: Vector2) -> void:
	#init()
	var gfx_start_pos := hlp.logic_to_iso(start_pos)
	var gfx_end_pos := hlp.logic_to_iso(target_pos)
	var angle := gfx_start_pos.angle_to_point(gfx_end_pos)
	print(start_pos, target_pos)

	if rotate_spr:
		$Sprite.rotate(angle + (45.0 / (2 * PI)))

	parent_pos = start_pos
	currently_moved_dist = 0.0
	target_vec = target_pos - start_pos
	to_move_dist = target_vec.length()
	shooting = true


func _process(delta: float) -> void:
	if (shooting == true):
		var dist_moved_delta: Vector2 = (vel - decrease_sf * currently_moved_dist / to_move_dist)  * target_vec.normalized() * delta
		position += dist_moved_delta 
		currently_moved_dist += dist_moved_delta.length()
		set_sprite_pos(parent_pos + position)
		if currently_moved_dist >= to_move_dist:
			shooting = false
			emit_signal("hit_target")
			print("hit_target")

func set_sprite_pos(logic_pos: Vector2) -> void:
	var norm_pos := (logic_pos / cst.LOGIC_SQ_W)
	if stg.draw_iso:
		$Sprite.global_position = hlp.norm_to_iso(cst.BOARD_DRAW_SCALE * norm_pos)
	else:
		$Sprite.global_position = logic_pos
