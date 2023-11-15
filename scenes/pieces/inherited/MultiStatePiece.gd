extends "res://scenes/pieces/Piece.gd"


func post_gfx_move() -> void:
	move_ended = true
	$Audio/Move.stop()
	if moving_to_attack and stg.classic_icons == false:
		$Audio/AttackDelay.start()
		await play_attack_anim()
	var sprite: AnimatedSprite2D = graphics.sprite
	sprite.play(graphics.passive_anim)
	sprite.stop()

	moving = false
	moving_to_attack = false
	gfx_manager.after_piece_finished_moving()
	
	graphics.passive_anim = str(logic.current_mv_state) + "_passive"
	graphics.sprite.play(str(logic.current_mv_state) + "_passive")
	graphics.sprite.stop()
	graphics.attack_anim = str(logic.current_mv_state) + "_attack"
