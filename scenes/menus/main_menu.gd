extends Node2D

var inc := 0

func _process(_delta: float):
	inc += 1
	if inc % 7 == 0:
		var p_layer := $Canv/HSplit/Castle/PBG/PLayer
		p_layer.motion_offset.x += 1
	if inc > 2000:
		inc = 0
