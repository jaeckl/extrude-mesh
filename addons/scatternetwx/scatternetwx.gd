@tool
extends EditorPlugin

var EdgeGizmo = preload("res://addons/scatternetwx/GraphEdge3DGizmo.gd")
var gismo = EdgeGizmo.new()
func _enter_tree():
	add_node_3d_gizmo_plugin(gismo)
	pass


func _exit_tree():
	remove_node_3d_gizmo_plugin(gismo)
	# Clean-up of the plugin goes here.)
	pass
