extends Node2D

var idx: int = 0
signal turn_to_faction(faction_idx)

func _ready():
	var codex = get_parent().get_parent().get_parent()
	turn_to_faction.connect(Callable(codex, "tab_click"))

func init(set_idx):
	idx = set_idx
	$Hover/Sprite.play("open")
	await $Hover/Sprite.animation_finished
	$Hover/Icon.show()
	$Hover/Icon.play(str(idx))
	

func _on_hover_mouse_entered():
	$Hover/Sprite.play("hover")


func _on_hover_mouse_exited():
	$Hover/Sprite.play("default")


func _on_hover_input_event(_viewport, _event, _shape_idx):
	if Input.is_action_just_pressed("click"):
		turn_to_faction.emit(idx)
