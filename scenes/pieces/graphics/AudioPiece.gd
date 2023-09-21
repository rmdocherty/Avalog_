extends Node2D

var playing_attack: bool = false
var start_attack: bool = false

func timer_finished() -> void:
	start_attack = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if start_attack == true and playing_attack == false:
		$Attack.play()
		start_attack = false
		playing_attack = false
