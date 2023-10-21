extends "res://scenes/pieces/Piece.gd"
var projectile_class = preload("res://scenes/pieces/Projectile.tscn")

func play_attack_anim() -> void:
	var sprite: AnimatedSprite2D = graphics.sprite
	sprite.play(graphics.attack_anim)
	await sprite.animation_finished

	var projectile = projectile_class.instantiate()
	graphics.add_child(projectile)
	projectile.shoot(logic.position, logic.position + to_move.normalized() * logic.ranged_dist)
	sprite.play(graphics.passive_anim)
	await projectile.hit_target
	$Audio/Hit.play()
	graphics.remove_child(projectile)
	sprite.play(graphics.passive_anim)
	sprite.stop()
