class_name GraphEdge3DGizmo extends EditorNode3DGizmo


func get_name():
	return "CustomNode"

func _has_gizmo(node):
	return node is ExtrudePlane3D
	
func _redraw():
	clear()
	add_mesh()
