extends "res://scenes/pieces/inherited/RangedPiece.gd"


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
	
	if logic.current_mv_state == 0 and mixed_move_types == false:
		ranged = false
		logic.reset_ranged_pos()
	else:
		ranged = true
		#logic.reset_ranged_pos()


func play_attack_anim() -> void:
	var sprite: AnimatedSprite2D = graphics.sprite
	sprite.play(graphics.attack_anim)
	await sprite.animation_finished
	
	if ranged:
		var projectile = projectile_class.instantiate()
		graphics.add_child(projectile)
		projectile.shoot(logic.position, logic.position + to_move.normalized() * logic.ranged_dist, proj_sprite)
		sprite.play(graphics.passive_anim)
		await projectile.hit_target
		$Audio/Hit.play()
		graphics.remove_child(projectile)
	sprite.play(graphics.passive_anim)
	sprite.stop()
