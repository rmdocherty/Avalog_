extends "res://scenes/pieces/LogicPiece.gd"

@onready var parent: LogicPiece = get_parent()

func _ready() -> void:
	colour = parent.colour

func on_overlap(area: Area2D) -> void:
	# If enemy piece impinges on this, delete
	var is_enemy = area.colour != colour and colour != cst.colour.NONE
	if is_enemy and ((area.state == states.MOVED) || (area.state == states.ATTACKING)) : # being taken
		delete()
	elif state == states.MOVED and is_enemy: # taking
		state = states.ATTACKING

func delete() -> void:
	get_parent().delete()
	collision_layer = 10
	state = states.DEAD
	position = Vector2(-10000, -10000)
	set_process_input(false)

func remove() -> void:
	print("removing")
	collision_layer = 10
	state = states.DEAD
	position = Vector2(-8000, -80000)
	set_process_input(false)
	queue_free()
