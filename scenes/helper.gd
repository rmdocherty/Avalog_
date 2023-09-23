extends Node


func load_child_remove_parent(node_path: String, parent: Node, pass_node: Node=null) -> void:
	var child: Node = load(node_path).instantiate()
	get_tree().get_root().add_child(child)
	if pass_node != null:
		parent.remove_child(pass_node)
		child.add_child(pass_node)
	get_tree().get_root().remove_child(parent)

func norm_to_iso(vec: Vector2) -> Vector2:
	var screen_x = (vec[0] - vec[1]) * cst.ISO[0] / 2.
	var screen_y = (vec[0] + vec[1]) * cst.ISO[1] / 2.
	return Vector2(screen_x, screen_y)

func iso_to_norm(iso_vec: Vector2) -> Vector2:
	var map_x = (iso_vec[0] / cst.ISO[0] + iso_vec[1] / cst.ISO[1])
	var map_y = (iso_vec[1] / cst.ISO[1] - iso_vec[0] / cst.ISO[0])
	return Vector2(map_x, map_y)

func logic_to_iso(logical_vec: Vector2) -> Vector2:
	return norm_to_iso(logical_vec / cst.LOGIC_SQ_W)

func iso_to_logic(iso_vec: Vector2) -> Vector2:
	return iso_to_norm(iso_vec) * cst.LOGIC_SQ_W
