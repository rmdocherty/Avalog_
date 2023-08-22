extends Node2D

@onready var sprite: AnimatedSprite2D = $Sprite

func mouse_entered_circle() -> void:
	sprite.play('0_passive')

func _mouse_exited_circle() -> void:
	sprite.play("0_passive")
	sprite.stop()

func show_lines() -> void:
	pass

func flip_sprite() -> void:
	sprite.flip_h = true

func change_player_circle(state: String) -> void:
	$Phantom/PlayerCircle.set_colour(state)

func _ready() -> void:
	sprite.apply_scale(cst.PIECE_DRAW_SCALE)
	if cst.draw_iso:
		sprite.show()
		$Icon.hide()
	else:
		sprite.hide()
		$Icon.show()
	#$Phantom/PlayerCircle.set_colour("active")
	$Phantom/Hover.polygon = $Phantom/PlayerCircle.inner_points



