extends Label

var n_dots: int = 0
var time_elapsed: float = 0
@export var original_text := "Waiting"

func _set_text(n: int) -> String:
	var dots := ""
	for i in range(n):
		dots += "."
	return original_text + dots

func _process(delta):
	time_elapsed += delta
	if time_elapsed > 0.35:
		n_dots = (n_dots + 1) % 4
		text = _set_text(n_dots)
		time_elapsed = 0
